# 🏗️ Transition Checklist Dashboard

## สถาปัตยกรรมระบบ (Architecture Overview)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────┐
│ SharePoint       │     │ Power Automate   │     │ OneDrive    │
│ Demand Folders   │────▶│ (Scheduled Flow) │────▶│ JSON + HTML │
│ + Excel Checklist│     │ Cloud - No Admin │     │ Dashboard   │
└─────────────────┘     └──────────────────┘     └──────┬──────┘
                                                         │
                                                         ▼
                                                  ┌─────────────┐
                                                  │ Browser      │
                                                  │ (Any device) │
                                                  └─────────────┘
```

## ✅ คุณสมบัติ
- ไม่ต้องมี Server
- ไม่ต้องมีสิทธิ์ Admin
- ไม่ต้อง Authentication เพิ่ม (ใช้ M365 session ที่ login อยู่)
- ไม่ต้อง run script บน SharePoint
- Power Automate ทำงานบน Cloud
- Dashboard เป็น Static HTML วางบน OneDrive

## 📁 โครงสร้างไฟล์
```
├── README.md                              # คู่มือนี้
├── dashboard/
│   └── index.html                         # Dashboard UI (Single-file)
├── power-automate/
│   ├── flow-guide.md                      # คู่มือสร้าง Power Automate Flow
│   └── flow-definition.json               # Flow template
├── sample-data/
│   └── dashboard_data.json                # ตัวอย่าง JSON data
├── copilot-agent/
│   └── agent-setup-guide.md               # คู่มือสร้าง Copilot Agent
└── deployment/
    └── deploy-guide.md                    # คู่มือ Deploy ละเอียด
```

## 🚀 Quick Start
ดูคู่มือ Deploy ละเอียดที่ [deployment/deploy-guide.md](deployment/deploy-guide.md)