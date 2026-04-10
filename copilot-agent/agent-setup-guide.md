# คู่มือสร้าง Microsoft 365 Copilot Agent: Transition Checklist Assistant

## ภาพรวม (Overview)

Copilot Agent นี้จะช่วย:
- ตอบคำถามเกี่ยวกับสถานะ Demand Checklist
- เปิด Dashboard URL เมื่อถามหา
- อ่านข้อมูลจาก dashboard_data.json และวิเคราะห์
- ทำงานผ่าน Microsoft 365 Copilot (Teams, Outlook, Word, etc.)

---

## Option A: Copilot Studio (แนะนำ) ⭐

### ขั้นตอนที่ 1: สร้าง Declarative Agent ใน Copilot Studio

1. ไปที่ [copilotstudio.microsoft.com](https://copilotstudio.microsoft.com)
2. Sign in ด้วย account Banpu
3. คลิก **"+ New agent"**
4. เลือก **"New agent"** (ไม่ใช่ template)
5. ตั้งชื่อ: `Transition Checklist Assistant`
6. ใส่ Description: `ช่วยตรวจสอบสถานะ Development Transition Checklist ก่อน DAC#2`

### ขั้นตอนที่ 2: Configure Instructions

ใน **"Instructions"** section ใส่:

```
คุณเป็น Transition Checklist Assistant สำหรับ Digital Capability Center (Banpu)

หน้าที่ของคุณ:
1. ตอบคำถามเกี่ยวกับสถานะ Development Transition Checklist ก่อน DAC#2
2. แสดงลิงก์ไปยัง Dashboard เมื่อถูกถาม
3. สรุปสถานะ Demand แต่ละ folder
4. บอกว่าเอกสารไหนยังขาดอยู่ (Missing)

ลิงก์ Dashboard: [DASHBOARD_URL_PLACEHOLDER]
ลิงก์ SharePoint: https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation

เมื่อผู้ใช้ถามว่า:
- "Dashboard อยู่ที่ไหน" / "เปิด dashboard" → ให้ลิงก์ Dashboard
- "DMND0007240 เป็นยังไง" → สรุปสถานะของ demand นั้น
- "demand ไหนครบแล้ว" → รายการ Complete demands
- "มีกี่ demand ที่ยังขาดเอกสาร" → สรุปสถิติ

ตอบทั้งภาษาไทยและอังกฤษตามที่ผู้ใช้ถาม
```

### ขั้นตอนที่ 3: เพิ่ม Knowledge Source

1. คลิก **"Knowledge"** tab
2. คลิก **"+ Add knowledge"**
3. เลือก **"File"** หรือ **"SharePoint"**
4. Upload ไฟล์ `dashboard_data.json` จาก OneDrive
   - หรือ ใส่ SharePoint URL ของไฟล์ JSON โดยตรง

### ขั้นตอนที่ 4: เพิ่ม Action (เปิด Dashboard)

1. คลิก **"Actions"** tab
2. คลิก **"+ Add action"**
3. เลือก **"Open URL"**
4. ตั้งชื่อ: `Open Dashboard`
5. URL: `[ใส่ Dashboard URL ของคุณ]`
6. Trigger phrases:
   - "เปิด dashboard"
   - "ดู dashboard"
   - "show dashboard"
   - "open checklist dashboard"

### ขั้นตอนที่ 5: Publish Agent

1. คลิก **"Publish"** (มุมบนขวา)
2. รอ 2-5 นาที
3. คลิก **"Go to Channels"**
4. เลือก **"Microsoft Teams"** > **"Add to Teams"**

---

## Agent Manifest (declarativeAgent.json)

สร้างไฟล์นี้สำหรับ Teams App Package:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/copilot/declarative-agent/v1.0/schema.json",
  "version": "v1.0",
  "name": "Transition Checklist Assistant",
  "description": "ช่วยตรวจสอบสถานะ Development Transition Checklist ก่อน DAC#2 สำหรับ Digital Capability Center",
  "instructions": "คุณเป็น Transition Checklist Assistant สำหรับ Digital Capability Center (Banpu). ช่วยตรวจสอบสถานะเอกสารใน Development Transition Checklist และตอบคำถามเกี่ยวกับ Demand folders. Dashboard URL: [DASHBOARD_URL]. Data ล่าสุดอยู่ที่ OneDrive: /Claude/Transition Checklist/dashboard_data.json",
  "capabilities": [
    {
      "name": "WebSearch"
    },
    {
      "name": "OneDriveAndSharePoint",
      "items_by_url": [
        {
          "url": "https://banpugroup-my.sharepoint.com/personal/sitthinon_m_banpu_co_th/Documents/Claude/Transition%20Checklist/dashboard_data.json"
        }
      ]
    }
  ],
  "conversation_starters": [
    {
      "title": "ดูสถานะ Dashboard",
      "text": "ช่วยเปิด Transition Checklist Dashboard ให้หน่อย"
    },
    {
      "title": "Demand ใดครบแล้ว?",
      "text": "Demand folder ไหนบ้างที่เอกสารครบแล้ว (Complete)?"
    },
    {
      "title": "เอกสารขาดอะไร?",
      "text": "DMND0007240 ยังขาดเอกสารอะไรบ้าง?"
    },
    {
      "title": "สรุปภาพรวม",
      "text": "ช่วยสรุปสถานะ Transition Checklist ทั้งหมดให้หน่อย"
    }
  ]
}
```

---

## Option B: Teams App with Embedded Dashboard

### ขั้นตอนที่ 1: สร้าง Teams App ด้วย Teams Toolkit

**Prerequisites:** Visual Studio Code + Teams Toolkit Extension

1. เปิด VS Code
2. คลิก Teams Toolkit icon (sidebar)
3. คลิก **"Create a New App"**
4. เลือก **"Tab"** > **"Basic Tab"**
5. ตั้งชื่อ: `Transition Checklist`

### ขั้นตอนที่ 2: แก้ไข manifest.json

แก้ไขไฟล์ `appPackage/manifest.json`:

```json
{
  "$schema": "https://developer.microsoft.com/en-us/json-schemas/teams/v1.17/MicrosoftTeams.schema.json",
  "manifestVersion": "1.17",
  "version": "1.0.0",
  "id": "YOUR-APP-ID-GUID",
  "developer": {
    "name": "Digital Capability Center",
    "websiteUrl": "https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation",
    "privacyUrl": "https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation",
    "termsOfUseUrl": "https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation"
  },
  "name": {
    "short": "Transition Checklist",
    "full": "Development Transition Checklist Dashboard"
  },
  "description": {
    "short": "ตรวจสอบสถานะ Transition Checklist ก่อน DAC#2",
    "full": "Dashboard สำหรับตรวจสอบสถานะเอกสารใน Development Transition Checklist ของแต่ละ Demand folder"
  },
  "icons": {
    "color": "color.png",
    "outline": "outline.png"
  },
  "accentColor": "#1a365d",
  "staticTabs": [
    {
      "entityId": "checklistDashboard",
      "name": "Checklist Dashboard",
      "contentUrl": "YOUR-DASHBOARD-URL",
      "websiteUrl": "YOUR-DASHBOARD-URL",
      "scopes": ["personal", "team", "groupchat"]
    }
  ],
  "configurableTabs": [
    {
      "configurationUrl": "YOUR-DASHBOARD-URL?config=1",
      "canUpdateConfiguration": true,
      "scopes": ["team", "groupchat"]
    }
  ],
  "permissions": [
    "identity",
    "messageTeamMembers"
  ],
  "validDomains": [
    "banpugroup-my.sharepoint.com",
    "*.sharepoint.com"
  ]
}
```

### ขั้นตอนที่ 3: Deploy ไปยัง Teams

**วิธีที่ 1: Sideload (สำหรับ Test)**
1. Zip ไฟล์ทั้งหมดใน appPackage/
2. Teams > Apps > Manage your apps > Upload an app
3. เลือกไฟล์ zip

**วิธีที่ 2: Teams Admin Center (สำหรับ Production)**
1. ไปที่ [admin.teams.microsoft.com](https://admin.teams.microsoft.com)
2. Teams apps > Manage apps > Upload new app
3. อัปโหลด zip package

---

## Option C: Power Virtual Agents (Basic Bot)

### ขั้นตอนที่ 1: สร้าง Bot ใน Copilot Studio (PVA)

1. ไปที่ [copilotstudio.microsoft.com](https://copilotstudio.microsoft.com)
2. คลิก **"+ New chatbot"**
3. ตั้งชื่อ: `Checklist Bot`
4. ภาษา: Thai

### ขั้นตอนที่ 2: สร้าง Topics

**Topic 1: ดู Dashboard**
- Trigger phrases:
  - "ดู dashboard"
  - "เปิด checklist"
  - "transition checklist"
- Response:
  ```
  นี่คือลิงก์ไปยัง Transition Checklist Dashboard ครับ:
  
  📊 [Transition Checklist Dashboard](YOUR-DASHBOARD-URL)
  
  Dashboard จะแสดงสถานะเอกสารของทุก Demand folder อัปเดตทุกวันเวลา 8:00 น.
  ```

**Topic 2: ถามสถานะ Demand**
- Trigger phrases:
  - "DMND{number} เป็นยังไง"
  - "สถานะ demand"
  - "ขาดเอกสารอะไร"
- Response:
  ```
  กรุณาดูข้อมูลล่าสุดได้ที่ Dashboard ครับ:
  📊 [Transition Checklist Dashboard](YOUR-DASHBOARD-URL)
  
  คุณสามารถ:
  - ค้นหาด้วย Demand ID ในช่อง Search
  - กรองตาม Status (Complete/Partial/Missing)
  - คลิก "View Details" เพื่อดูรายละเอียดเอกสาร
  ```

### ขั้นตอนที่ 3: Publish ไปยัง Teams

1. คลิก **"Publish"** ใน Copilot Studio
2. ไปที่ **"Channels"** > **"Microsoft Teams"**
3. คลิก **"Turn on Teams"**
4. Copy invitation link แชร์ให้ทีม

---

## การ Configure Dashboard URL ใน Agent

หลังจาก Deploy Dashboard ไปยัง OneDrive/SharePoint แล้ว ให้:

1. Copy URL ของ `index.html` (SharePoint sharing link)
2. แทนที่ `[DASHBOARD_URL]` ในทุกที่ด้วย URL นั้น
3. สำหรับ OneDrive: ต้องเป็น "Anyone with the link can view" sharing

### รูปแบบ URL ที่แนะนำ:

**SharePoint Page (ดีที่สุด):**
```
https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation/SitePages/TransitionChecklist.aspx
```

**GitHub Pages (ง่ายที่สุด):**
```
https://sitthinonm.github.io/JB_GitRepo/dashboard/
```

**OneDrive Direct (อาจมีปัญหา browser security):**
```
https://banpugroup-my.sharepoint.com/personal/sitthinon_m_banpu_co_th/Documents/Claude/Transition%20Checklist/index.html
```

---

## ตัวอย่างการสนทนากับ Agent

```
👤 User: สวัสดี ช่วยบอกสถานะ checklist ให้หน่อย

🤖 Agent: สวัสดีครับ! ผมคือ Transition Checklist Assistant
สามารถดูสถานะล่าสุดได้ที่ Dashboard ครับ:
📊 https://[your-dashboard-url]

ข้อมูลล่าสุด (อัปเดต: 10 เม.ย. 2026 10:30):
- Total Demands: 6 folders
- ✅ Complete: 1 (DMND0006744)
- ⚠️ Partial: 4 folders
- ❌ Missing all: 1 (DMND0005303)

ต้องการข้อมูลเพิ่มเติมสำหรับ Demand ไหนไหมครับ?

👤 User: DMND0007240 ขาดอะไรบ้าง?

🤖 Agent: Demand - DMND0007240 (พบ 2/6 เอกสาร):

✅ พบแล้ว:
  1. BRD - Bunyut port stability.docx
  4. DAC2-Port Stability Real Time Monitoring.pptx

❌ ยังขาด:
  2. BRD - Specifications (BRS/BRDD)
  3. RFP/TOR
  5. Resource Plan
  6. Project Cost

คลิก "View Details" ใน Dashboard เพื่อดูรายละเอียดเพิ่มเติมครับ
```

---

*สร้างโดย: Digital Capability Center | อัปเดต: เมษายน 2026*
