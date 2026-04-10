# คู่มือ Deploy: Transition Checklist Dashboard

## ภาพรวม

คู่มือนี้จะแนะนำการ Deploy ระบบ Transition Checklist Dashboard ทั้งหมด ตั้งแต่เริ่มต้นจนถึงแชร์ให้ทีม

---

## Phase 1: Download & Configure

### ขั้นตอนที่ 1: ดาวน์โหลดไฟล์จาก GitHub

**วิธีที่ 1: Download ZIP**
1. ไปที่ GitHub repository: `https://github.com/sitthinonm/JB_GitRepo`
2. คลิกปุ่ม **"Code"** (สีเขียว)
3. คลิก **"Download ZIP"**
4. แตกไฟล์ ZIP ไปยังโฟลเดอร์ที่ต้องการ

**วิธีที่ 2: Git Clone**
```bash
git clone https://github.com/sitthinonm/JB_GitRepo.git
```

### ขั้นตอนที่ 2: เปิดและแก้ไขไฟล์ dashboard/index.html

1. เปิดไฟล์ `dashboard/index.html` ด้วย Text Editor (Notepad++, VS Code, Notepad)
2. หาบรรทัดนี้ที่ด้านบนของ `<script>` section:

```javascript
const DATA_URL = './dashboard_data.json';
```

3. เปลี่ยนเป็น URL ของไฟล์ JSON ใน OneDrive ของคุณ:

```javascript
// ตัวอย่าง OneDrive direct download link:
const DATA_URL = 'https://banpugroup-my.sharepoint.com/personal/sitthinon_m_banpu_co_th/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fsitthinon_m_banpu_co_th%2FDocuments%2FClaude%2FTransition%20Checklist%2Fdashboard_data.json';
```

> 💡 **วิธีหา Download URL:**
> 1. ไปที่ OneDrive
> 2. คลิกขวาที่ `dashboard_data.json`
> 3. คลิก "Share" > Copy link
> 4. เปลี่ยน `?...` ส่วนท้ายเป็น `?download=1`

### ขั้นตอนที่ 3: แก้ไข Manual Trigger URL (ถ้าต้องการ)

ในไฟล์เดียวกัน หาบรรทัด:

```javascript
const MANUAL_TRIGGER_URL = '';
```

เปลี่ยนเป็น HTTP Trigger URL ของ Power Automate Flow (จะได้ในภายหลัง):

```javascript
const MANUAL_TRIGGER_URL = 'https://prod-XX.westus.logic.azure.com:443/workflows/...';
```

---

## Phase 2: Deploy Dashboard ไปยัง OneDrive/SharePoint

### วิธีที่ 1: SharePoint Page (แนะนำ ⭐)

**ข้อดี:** ทำงานได้ดีที่สุด, no CORS issue, แชร์ง่าย

1. ไปที่ SharePoint site: `banpugroup.sharepoint.com/sites/Internal_Digital_Innovation`
2. คลิก **"Pages"** ใน left sidebar
3. คลิก **"+ New"** > **"Site Page"**
4. ตั้งชื่อ page: `Transition Checklist Dashboard`
5. ใน page editor คลิก **"+"** (Add a new section)
6. เลือก **"Embed"** web part
7. วาง HTML หรือ iframe URL
8. คลิก **"Publish"**

**หรือ ใช้ Script Editor web part:**
1. เปิด SharePoint page ในโหมด Edit
2. เพิ่ม **"Embed"** web part
3. ใส่ iframe code:
```html
<iframe 
  src="https://banpugroup-my.sharepoint.com/personal/sitthinon_m_banpu_co_th/Documents/Claude/Transition%20Checklist/index.html"
  width="100%"
  height="900px"
  frameborder="0"
  allowfullscreen>
</iframe>
```

---

### วิธีที่ 2: OneDrive + Direct Browser Access

**ข้อจำกัด:** OneDrive ไม่ render HTML โดยตรง ต้องใช้วิธีพิเศษ

**ขั้นตอนที่ 1: Upload ไฟล์**
1. เปิด OneDrive: `https://banpugroup-my.sharepoint.com/personal/sitthinon_m_banpu_co_th`
2. ไปที่ `Documents > Claude > Transition Checklist`
   - ถ้ายังไม่มีโฟลเดอร์ให้สร้างก่อน
3. Upload ไฟล์:
   - `dashboard/index.html`
   - `sample-data/dashboard_data.json`

**ขั้นตอนที่ 2: วิธีเปิด HTML จาก OneDrive**

OneDrive จะ download ไฟล์แทนการแสดงผล ใช้วิธีเหล่านี้:

**Option A: แก้ URL ให้ preview**
```
URL เดิม (download):
https://banpugroup-my.sharepoint.com/:u:/g/personal/sitthinon_m_banpu_co_th/FILEID

เปลี่ยนเป็น:
https://view.officeapps.live.com/op/view.aspx?src=ENCODED_FILE_URL
```

**Option B: ใช้ SharePoint Document Library**
1. Upload `index.html` ไปยัง SharePoint Document Library
2. ไฟล์ HTML จะเปิดในบางกรณีผ่าน browser โดยตรง
3. Right-click > Open in browser

---

### วิธีที่ 3: GitHub Pages (ง่ายที่สุด ⭐⭐⭐)

**ข้อดี:** ง่ายมาก, ทำงานได้สมบูรณ์, ไม่มีปัญหา CORS

**ขั้นตอนที่ 1: Enable GitHub Pages**
1. ไปที่ Repository: `https://github.com/sitthinonm/JB_GitRepo`
2. คลิก **"Settings"** tab
3. Scroll ลงหา **"Pages"** section (sidebar)
4. ใต้ **"Source"** เลือก:
   - Branch: `main` (หรือ branch ปัจจุบัน)
   - Folder: `/ (root)` หรือ `/docs`
5. คลิก **"Save"**
6. รอ 1-5 นาที

**ขั้นตอนที่ 2: URL ของ Dashboard**
```
https://sitthinonm.github.io/JB_GitRepo/dashboard/
```

**ขั้นตอนที่ 3: แก้ไข DATA_URL ใน index.html**

เมื่อใช้ GitHub Pages, dashboard จะ fetch `dashboard_data.json` แบบ relative path
ใส่ sample data ที่ `sample-data/dashboard_data.json` แล้วอัปเดต DATA_URL:

```javascript
const DATA_URL = '../sample-data/dashboard_data.json';
```

หรือเพื่อให้ fetch จาก OneDrive (live data):
```javascript
const DATA_URL = 'https://[onedrive-direct-download-url]';
```

> ⚠️ **CORS Issue:** การ fetch ข้าม domain จาก GitHub Pages ไปยัง OneDrive อาจมี CORS issue
> Dashboard จะ fallback เป็น Demo Mode โดยอัตโนมัติถ้า fetch ไม่สำเร็จ

---

## Phase 3: Set Up Power Automate Flow

ดูคู่มือละเอียดที่: [power-automate/flow-guide.md](../power-automate/flow-guide.md)

### Quick Setup Checklist:

- [ ] ไปที่ [make.powerautomate.com](https://make.powerautomate.com)
- [ ] คลิก **"+ Create"** > **"Automated cloud flow"**
- [ ] ตั้งชื่อ: `Transition Checklist Scanner`
- [ ] เพิ่ม Recurrence trigger (Daily 8 AM Bangkok)
- [ ] เพิ่ม SharePoint "List folder" action
- [ ] เพิ่ม Filter array (Demand/Amalgamation folders)
- [ ] เพิ่ม Excel "List rows" action (อ่าน Checklist_Dev_AI.xlsx)
- [ ] เพิ่ม nested Apply to each + Filter array สำหรับ file matching
- [ ] เพิ่ม OneDrive "Create/Update file" action
- [ ] Test flow ด้วย Manual run
- [ ] Verify `dashboard_data.json` ถูกสร้างใน OneDrive

### เปิดใช้งาน HTTP Trigger (สำหรับ Manual Refresh จาก Dashboard):

1. เปิด Flow > คลิกที่ Recurrence trigger
2. คลิก **"+"** ข้างๆ trigger > **"Add trigger"**
3. เพิ่ม **"When a HTTP request is received"** trigger
4. หลัง Save คัดลอก "HTTP POST URL"
5. ใส่ URL นั้นใน `MANUAL_TRIGGER_URL` ใน `index.html`

---

## Phase 4: Create Copilot Agent

ดูคู่มือละเอียดที่: [copilot-agent/agent-setup-guide.md](../copilot-agent/agent-setup-guide.md)

### Quick Setup:
1. ไปที่ [copilotstudio.microsoft.com](https://copilotstudio.microsoft.com)
2. สร้าง Declarative Agent ใหม่
3. Copy-paste instructions จากคู่มือ
4. เพิ่ม Knowledge source: `dashboard_data.json` จาก OneDrive
5. Publish ไปยัง Teams

---

## Phase 5: Test & Verify

### ทดสอบ Dashboard:

1. **ทดสอบ Demo Mode:**
   - เปิด `index.html` บน local computer
   - ควรแสดง Dashboard พร้อม Demo data badge

2. **ทดสอบ Live Mode:**
   - เปิด Dashboard URL (GitHub Pages หรือ SharePoint)
   - ถ้า `dashboard_data.json` accessible → จะโหลด live data
   - ถ้า fetch fail → จะแสดง Demo data โดยอัตโนมัติ

3. **ทดสอบ Features:**
   - [ ] Search ด้วย Demand ID
   - [ ] Filter by Status
   - [ ] Sort ต่างๆ
   - [ ] Click "View Details" เพื่อเปิด Modal
   - [ ] Dark/Light mode toggle
   - [ ] Demo/Live mode toggle

### ทดสอบ Power Automate Flow:

1. เปิด Flow ใน make.powerautomate.com
2. คลิก **"Test"** > **"Manually"** > **"Run flow"**
3. ตรวจสอบ Run history
4. Verify ไฟล์ `dashboard_data.json` ถูกอัปเดตใน OneDrive
5. Refresh Dashboard เพื่อดูข้อมูลใหม่

### ตรวจสอบ Data:

เปิด `dashboard_data.json` จาก OneDrive แล้วตรวจสอบ:
```json
{
  "metadata": {
    "lastChecked": "2026-04-10T10:30:00+07:00",  // ✅ วันที่ปัจจุบัน
    "totalDemandsScanned": 12                       // ✅ จำนวน demand จริง
  },
  "demands": [...]                                  // ✅ มีข้อมูล
}
```

---

## Phase 6: Share with Team

### วิธีแชร์ Dashboard:

**Option 1: ส่ง Link**
1. Copy URL ของ Dashboard
2. ส่งผ่าน Teams หรือ Email:
   ```
   📊 Transition Checklist Dashboard (Before DAC#2)
   
   ลิงก์: https://[dashboard-url]
   
   Dashboard จะแสดงสถานะเอกสารของทุก Demand folder
   อัปเดตอัตโนมัติทุกวัน 8:00 น.
   ```

**Option 2: Pin ใน Teams Channel**
1. เปิด Teams Channel ที่ต้องการ
2. คลิก **"+"** ที่ tab bar
3. เลือก **"Website"**
4. ตั้งชื่อ: `Checklist Dashboard`
5. URL: ใส่ Dashboard URL
6. คลิก **"Save"**

**Option 3: Add ใน SharePoint Intranet**
1. ไปที่ SharePoint Home page
2. คลิก Edit page
3. เพิ่ม Link หรือ Highlighted Content web part
4. ชี้ไปที่ Dashboard URL

### การตั้งค่า Permissions:

**สำหรับ GitHub Pages:**
- เป็น public แล้วโดยอัตโนมัติ (ถ้า repo เป็น public)
- ไม่ต้องตั้งค่าเพิ่ม

**สำหรับ OneDrive:**
1. คลิกขวาที่ `index.html` ใน OneDrive
2. คลิก **"Share"**
3. เลือก **"Anyone in [Organization] can view"**
4. คัดลอก Link

**สำหรับ SharePoint Page:**
1. Publish page (ทำใน Phase 2)
2. หน้าจะ accessible ให้ทุกคนใน organization โดยอัตโนมัติ

---

## Troubleshooting

### Dashboard แสดง Demo data ตลอด
- ตรวจสอบ `DATA_URL` ในไฟล์ `index.html` ว่าถูกต้อง
- ตรวจสอบ CORS policy: fetch ข้าม domain อาจถูก block
- ตรวจสอบ OneDrive file permissions

### Power Automate Flow fail
- ดู error details ใน Run history
- ตรวจสอบ SharePoint path (ห้ามมี trailing slash)
- ตรวจสอบ Excel table name ตรงกับที่ config
- ตรวจสอบ Connector authentication

### Modal ไม่แสดง
- ตรวจสอบ browser console (F12) สำหรับ JavaScript errors
- ลอง refresh หน้า (Ctrl+F5)

### ตัวเลขใน Dashboard ไม่อัปเดต
- ตรวจสอบ Power Automate Flow ทำงานปกติ
- ตรวจสอบ `dashboard_data.json` ถูกอัปเดตแล้ว
- Hard refresh browser: Ctrl+Shift+R

---

## Architecture Diagram

```
[Power Automate Flow - Daily 8AM]
    │
    ├── Read SharePoint: 2026 Demand Folders
    │   └── Filter: Demand / Amalgamation folders
    │
    ├── Read Excel: Checklist_Dev_AI.xlsx
    │   └── Get all checklist rows
    │
    ├── For each Demand folder:
    │   ├── List files in folder
    │   └── For each checklist row:
    │       ├── Split Finding Docs Name by "/"
    │       └── Filter files (case-insensitive contains match)
    │
    └── Write OneDrive: dashboard_data.json
        
[Static HTML Dashboard - index.html]
    │
    ├── Fetch dashboard_data.json from OneDrive/GitHub
    │   └── (Fallback to DEMO_DATA if fetch fails)
    │
    ├── Render Stats Overview
    ├── Render Demand Cards Grid
    └── Show Detail Modal on click
```

---

*สร้างโดย: Digital Capability Center | เวอร์ชัน: 1.0.0 | อัปเดต: เมษายน 2026*
