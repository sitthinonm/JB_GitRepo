# คู่มือ Deploy: Transition Checklist Dashboard

## ภาพรวม

Dashboard นี้เป็น **Portable single-folder webapp** ที่ไม่ต้องมี server, ไม่ต้องมี Power Automate, และไม่ต้องมีสิทธิ์ Admin

แค่ copy โฟลเดอร์ไปวางที่ไหนก็ได้ แล้วเปิด `index.html` ใน browser → ใช้งานได้ทันที

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

### ขั้นตอนที่ 2: เตรียมโฟลเดอร์

สิ่งที่ต้องการมีแค่ **2 ไฟล์** ในโฟลเดอร์เดียว:

```
Transition Checklist/         ← ชื่อโฟลเดอร์อะไรก็ได้
├── index.html                ← Dashboard webapp
└── dashboard_data.json       ← ข้อมูล (จะสร้างทีหลังก็ได้)
```

1. Copy ไฟล์จาก `dashboard/` ไปวางในโฟลเดอร์ที่ต้องการ
2. ถ้ายังไม่มี `dashboard_data.json` ไม่เป็นไร — Dashboard จะเริ่มด้วย Demo Data

> 💡 **ไม่ต้องแก้ไขไฟล์ใดๆ** — index.html โหลดข้อมูลจาก `./dashboard_data.json` ในโฟลเดอร์เดียวกันอัตโนมัติ

---

## Phase 2: Deploy ไปยังตำแหน่งที่ต้องการ

### Option A: OneDrive (แนะนำ — ง่ายที่สุด)

1. เปิด **OneDrive** ผ่าน browser หรือ desktop app
2. สร้างโฟลเดอร์ชื่อ `Transition Checklist` (หรือชื่ออะไรก็ได้)
3. Upload ไฟล์ `index.html` และ `dashboard_data.json` เข้าไป
4. **วิธีเปิด Dashboard:**
   - คลิกที่ `index.html` ใน OneDrive
   - OneDrive จะเปิดเป็น Preview → คลิก **"Open in browser"** หรือ **"Download"** แล้วเปิดด้วย browser
   - หรือใช้ **OneDrive Sync** → เปิดไฟล์จาก folder ที่ sync ไว้ใน computer โดยตรง

> 💡 **วิธีที่ง่ายที่สุด:** ใช้ OneDrive Sync แล้วเปิด `index.html` จาก Explorer/Finder ตรงๆ

### Option B: SharePoint

1. ไปที่ SharePoint site ที่ต้องการ
2. ไปที่ **Documents** library
3. สร้างโฟลเดอร์แล้ว upload ไฟล์ทั้ง 2
4. เปิดเหมือนกับ OneDrive

### Option C: Local (ไม่ต้อง upload ไปไหนเลย)

1. แค่เปิด `index.html` ด้วย browser จากเครื่อง local ได้เลย
2. ข้อจำกัด: `fetch('./dashboard_data.json')` อาจโดน CORS block เมื่อเปิดเป็น `file://` protocol
3. แต่ไม่มีปัญหา — Dashboard จะ fallback ไปใช้ localStorage หรือ Demo Data อัตโนมัติ
4. พอแก้ไขข้อมูลและ Export JSON ครั้งแรกแล้ว ข้อมูลจะ save ใน localStorage ต่อไป

---

## Phase 3: วิธีใช้งาน Dashboard

### เพิ่ม Demand ใหม่
1. คลิกปุ่ม **"➕ Add Demand"**
2. กรอก **Demand ID** (เช่น `DMND0007240`)
3. **Folder Name** จะถูกสร้างอัตโนมัติ (แก้ไขได้)
4. กรอก **SharePoint URL** ของ folder (ถ้ามี, optional)
5. คลิก **"Create"**
6. ระบบจะสร้าง Demand พร้อม Checklist 6 รายการอัตโนมัติ

### แก้ไข Checklist Status
1. คลิก **"View Details"** ที่ Demand card
2. ในตาราง Checklist:
   - คลิกปุ่ม **"❌ Missing"** → เปลี่ยนเป็น **"✅ Found"** (หรือกลับกัน)
   - พิมพ์ **ชื่อไฟล์** ที่พบในช่อง "Matched File"
3. ทุกการแก้ไข auto-save ใน browser (localStorage) ทันที

### บันทึกข้อมูลเป็น JSON
1. คลิกปุ่ม **"💾 Export JSON"**
2. Browser จะ download ไฟล์ `dashboard_data.json`
3. **วางไฟล์ทับของเก่า** ในโฟลเดอร์เดียวกับ `index.html`
4. ครั้งต่อไปที่เปิด Dashboard → จะโหลดข้อมูลจากไฟล์นี้

### นำเข้าข้อมูลจาก JSON
1. คลิกปุ่ม **"📂 Import JSON"**
2. เลือกไฟล์ `dashboard_data.json`
3. ข้อมูลจะถูกโหลดเข้ามาทันที

### ลบ Demand
1. คลิกปุ่ม **🗑️** ที่มุมขวาบนของ Demand card
2. ยืนยันการลบ

---

## Phase 4: แชร์กับทีม

### วิธีที่ 1: แชร์โฟลเดอร์ OneDrive/SharePoint
1. คลิกขวาที่โฟลเดอร์ `Transition Checklist`
2. คลิก **"Share"** หรือ **"Copy link"**
3. ส่ง link ให้ทีม
4. ทุกคนที่มีสิทธิ์เข้า OneDrive/SharePoint จะเปิดได้

### วิธีที่ 2: OneDrive Sync
1. ให้ทีม Sync โฟลเดอร์ผ่าน OneDrive desktop app
2. ทุกคนจะมี shortcut เปิด `index.html` จาก Explorer ได้เลย

### วิธีที่ 3: Pin ใน Teams
1. ไปที่ Teams channel
2. คลิก **"+"** (Add tab)
3. เลือก **"Website"**
4. วาง URL ของ `index.html` จาก SharePoint
5. ทีมจะเปิด Dashboard ได้จาก Teams tab

---

## Phase 5: Workflow แนะนำ

### สำหรับ Demand Manager:
```
1. เปิด Dashboard → ดูว่า Demand ไหนยังไม่ครบ
2. ไปหาเอกสาร → Upload เข้า SharePoint Demand folder
3. กลับมาที่ Dashboard → คลิก "View Details"
4. คลิกสลับ ❌ Missing → ✅ Found
5. ใส่ชื่อไฟล์ที่ตรงกัน
6. คลิก "💾 Export JSON" → วางทับไฟล์เดิม
```

### สำหรับทีม:
```
1. เปิด Dashboard จาก shortcut
2. ดู Overview → เห็นสถานะทุก Demand
3. Filter / Search → หา Demand ที่ต้องการ
4. View Details → ดูรายละเอียด
```

---

## Phase 6: (Optional) เพิ่ม Power Automate

ถ้าต้องการให้ระบบ **scan ไฟล์ใน SharePoint อัตโนมัติ** แทนที่จะ update ด้วยมือ:

1. ดูคู่มือที่ [power-automate/flow-guide.md](../power-automate/flow-guide.md)
2. สร้าง Flow ตาม step-by-step guide
3. Flow จะสร้าง `dashboard_data.json` ให้อัตโนมัติทุกวัน
4. วาง JSON ในโฟลเดอร์เดียวกับ `index.html`

---

## ❓ FAQ

### Q: เปิด index.html แล้วเห็น Demo Data?
**A:** ปกติครับ — ถ้ายังไม่มีไฟล์ `dashboard_data.json` ในโฟลเดอร์เดียวกัน หรือเปิดเป็น `file://` protocol ระบบจะแสดง Demo Data ให้เห็น layout ก่อน เริ่มเพิ่ม Demand ได้เลยผ่านปุ่ม "➕ Add Demand"

### Q: ข้อมูลหายเมื่อเปลี่ยนเครื่อง?
**A:** ข้อมูลที่แก้ไขจะ save ใน localStorage ของ browser นั้นๆ ถ้าจะย้ายเครื่อง ให้คลิก **"💾 Export JSON"** แล้ว **วางไฟล์ในโฟลเดอร์เดียวกัน** → เครื่องอื่นจะโหลดได้

### Q: หลายคนแก้พร้อมกันได้ไหม?
**A:** ระบบนี้เป็น single-file ไม่มี concurrent editing ถ้าหลายคนต้องการแก้ แนะนำให้คนเดียวเป็นคน update แล้ว Export JSON วางไว้ คนอื่นจะเห็นอัตโนมัติ

### Q: รองรับ browser อะไรบ้าง?
**A:** Chrome, Edge, Firefox, Safari (modern versions)
