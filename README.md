# 🏗️ Transition Checklist Dashboard

**Portable single-folder webapp** สำหรับติดตามสถานะ Development Transition Checklist (Before DAC#2)

## ✨ คุณสมบัติ (Features)

- ✅ **ไม่ต้องมี Server** — เปิดไฟล์ HTML ใน browser ได้เลย
- ✅ **ไม่ต้องมี Power Automate** — จัดการข้อมูลผ่าน Dashboard UI ได้ตรงๆ
- ✅ **ไม่ต้องมีสิทธิ์ Admin** — ใช้สิทธิ์ M365 ปกติ
- ✅ **Portable** — Copy folder ไปวางที่ไหนก็ได้ (OneDrive / SharePoint / Local)
- ✅ **Single-file** — ทุกอย่างอยู่ใน `index.html` ไฟล์เดียว (CSS + JS inline, ไม่มี CDN)
- ✅ **Dark/Light mode** — สลับ theme ได้
- ✅ **Responsive** — ใช้ได้ทั้ง Desktop, Tablet, Mobile
- ✅ **Import/Export JSON** — โหลดและบันทึกข้อมูลเป็นไฟล์ JSON

## 🚀 Quick Start (3 ขั้นตอน)

### 1. Copy folder
Copy โฟลเดอร์ `dashboard/` ไปวางที่ต้องการ (OneDrive, SharePoint, หรือ local):
```
dashboard/
├── index.html              # Dashboard webapp
└── dashboard_data.json     # ข้อมูล (สร้างอัตโนมัติ หรือใช้ตัวอย่าง)
```

### 2. เปิด Dashboard
เปิด `index.html` ด้วย browser (Chrome, Edge, Firefox)

### 3. เริ่มใช้งาน
- คลิก **"➕ Add Demand"** เพื่อเพิ่ม Demand ใหม่
- คลิก **"View Details"** เพื่อดู/แก้ไข checklist
- คลิก **"💾 Export JSON"** เพื่อ save ข้อมูลเป็นไฟล์ JSON

## 📸 ตัวอย่างหน้าจอ

### Dashboard หลัก
- แสดง Stats Overview (Total, Complete, Partial, Missing)
- Cards แสดงทุก Demand พร้อม progress bar
- Filter/Search/Sort ได้

### Detail Modal
- ดูรายการ Checklist ทั้งหมด
- **คลิกสลับสถานะ** Found ↔ Missing ได้เลย
- ใส่ชื่อ Matched File ได้
- เพิ่ม Notes ได้

## 📁 โครงสร้างไฟล์
```
├── README.md                              # คู่มือนี้
├── dashboard/
│   ├── index.html                         # Dashboard webapp (single-file)
│   └── dashboard_data.json                # ข้อมูลตัวอย่าง
├── power-automate/                        # (Optional) ถ้าต้องการ auto-scan
│   ├── flow-guide.md                      # คู่มือสร้าง Power Automate Flow
│   └── flow-definition.json               # Flow template
├── sample-data/
│   └── dashboard_data.json                # ตัวอย่าง JSON data
├── copilot-agent/
│   └── agent-setup-guide.md               # คู่มือสร้าง Copilot Agent
└── deployment/
    └── deploy-guide.md                    # คู่มือ Deploy ละเอียด
```

## 🔄 วิธีจัดการข้อมูล

### การ Save/Load ข้อมูล
```
เปิด Dashboard → แก้ไขข้อมูล → Auto-save ใน browser (localStorage)
                                 ↓
                    คลิก "💾 Export JSON" → ได้ไฟล์ dashboard_data.json
                                 ↓
                    วางไฟล์ในโฟลเดอร์เดียวกับ index.html
                                 ↓
                    ครั้งต่อไปเปิด → โหลดข้อมูลจาก JSON อัตโนมัติ
```

### Data Priority:
1. `./dashboard_data.json` (ถ้ามีไฟล์อยู่ในโฟลเดอร์เดียวกัน)
2. `localStorage` (ข้อมูลที่ save ไว้ใน browser)
3. Demo Data (ข้อมูลตัวอย่างที่ built-in มาพร้อม)

## 📋 Checklist Template (Built-in)

เมื่อเพิ่ม Demand ใหม่ ระบบจะสร้าง Checklist อัตโนมัติ 6 รายการ:

| # | รายการ | บังคับ |
|---|--------|--------|
| 1 | BRD - Requirements (Cost & Benefit Analysis) | ✅ Y |
| 2 | BRD - Specifications | ✅ Y |
| 3 | RFP/TOR including system design | ❎ N |
| 4 | Architecture design (High Level) | ✅ Y |
| 5 | Resource Plan & Timeline | ✅ Y |
| 6 | Budget & Cost Center | ✅ Y |

## ⚙️ Optional: Power Automate (Auto-scan)

ถ้าต้องการให้ระบบ scan ไฟล์ใน SharePoint อัตโนมัติ สามารถเพิ่ม Power Automate Flow ได้:
- ดูคู่มือที่ [power-automate/flow-guide.md](power-automate/flow-guide.md)
- Flow จะสร้าง `dashboard_data.json` ให้อัตโนมัติทุกวัน

## 📖 คู่มือเพิ่มเติม
- [deployment/deploy-guide.md](deployment/deploy-guide.md) — คู่มือ Deploy ละเอียด
- [copilot-agent/agent-setup-guide.md](copilot-agent/agent-setup-guide.md) — วิธีสร้าง Copilot Agent