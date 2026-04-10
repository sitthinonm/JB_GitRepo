# คู่มือสร้าง Power Automate Flow: Transition Checklist Scanner

## ภาพรวม (Overview)

**Flow Name:** Transition Checklist Scanner  
**Type:** Automated Cloud Flow  
**Owner:** Digital Capability Center  
**สถานที่ทำงาน:** Power Automate Cloud (make.powerautomate.com)

Flow นี้จะ:
1. ทำงานอัตโนมัติทุกวัน 8:00 น. (Bangkok time)
2. Scan ทุก Demand folder ใน SharePoint
3. เทียบไฟล์กับ Checklist_Dev_AI.xlsx
4. สร้าง JSON file บน OneDrive สำหรับ Dashboard

---

## Prerequisites (สิ่งที่ต้องมีก่อน)

- [ ] Microsoft 365 account (Banpu)
- [ ] สิทธิ์ read ไฟล์ใน SharePoint site: `Internal_Digital_Innovation`
- [ ] สิทธิ์ write ไฟล์ใน OneDrive ของตัวเอง
- [ ] Power Automate license (มีใน Microsoft 365 Business)

---

## ขั้นตอนการสร้าง (Step-by-Step)

### เริ่มต้น: เปิด Power Automate

1. ไปที่ [make.powerautomate.com](https://make.powerautomate.com)
2. Sign in ด้วย account Banpu
3. คลิก **"+ Create"** > **"Automated cloud flow"**
4. ตั้งชื่อ: `Transition Checklist Scanner`
5. Search trigger: พิมพ์ `"Recurrence"` > เลือก **"Recurrence"**
6. คลิก **"Create"**

---

## Step 1: Trigger — Recurrence (Daily 8 AM)

**Action:** Schedule - Recurrence

| Setting | Value |
|---------|-------|
| Frequency | Day |
| Interval | 1 |
| Time zone | (UTC+07:00) Bangkok, Hanoi, Jakarta |
| At these hours | 8 |
| At these minutes | 0 |

> 💡 **หมายเหตุ:** Flow จะทำงานทุกวันเวลา 08:00 น. ตามเวลาไทย

---

## Step 2: Initialize Variable — varSiteUrl

**Action:** Variables - Initialize variable

| Setting | Value |
|---------|-------|
| Name | varSiteUrl |
| Type | String |
| Value | `https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation` |

> ⚠️ ใส่ URL แบบ full URL พร้อม https://

---

## Step 3: Initialize Variable — varDemandPath

**Action:** Variables - Initialize variable

| Setting | Value |
|---------|-------|
| Name | varDemandPath |
| Type | String |
| Value | `/Shared Documents/04_Digital Capability Center/Demand and Solution Management/Demand - Document/2026` |

---

## Step 4: Initialize Variable — varResults

**Action:** Variables - Initialize variable

| Setting | Value |
|---------|-------|
| Name | varResults |
| Type | Array |
| Value | `[]` |

---

## Step 5: Initialize Variable — varCurrentDemand

**Action:** Variables - Initialize variable

| Setting | Value |
|---------|-------|
| Name | varCurrentDemand |
| Type | Object |
| Value | `{}` |

---

## Step 6: Initialize Variable — varStartTime

**Action:** Variables - Initialize variable

| Setting | Value |
|---------|-------|
| Name | varStartTime |
| Type | String |
| Value | `@{utcNow()}` |

> ใช้ Expression: `utcNow()`

---

## Step 7: SharePoint — List Folder (Get Demand Folders)

**Action:** SharePoint - List folder

| Setting | Value |
|---------|-------|
| Site Address | `https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation` |
| File Identifier | `/Shared Documents/04_Digital Capability Center/Demand and Solution Management/Demand - Document/2026` |

> 💡 นี่คือ **"List folder"** action ซึ่งจะ return subfolders และ files ทั้งหมดในโฟลเดอร์นั้น

**Output ที่ได้:** Array ของ items (folders + files) ในโฟลเดอร์ 2026/

---

## Step 8: Filter Array — กรองเฉพาะ Demand และ Amalgamation Folders

**Action:** Data Operation - Filter array

| Setting | Value |
|---------|-------|
| From | `@{body('List_folder')?['value']}` |

**Condition (Advanced mode):**
```
@or(
  startsWith(item()?['Name'], 'Demand'),
  startsWith(item()?['Name'], 'Amalgamation')
)
```

> 💡 กด **"Edit in advanced mode"** แล้วใส่ expression ด้านบน

---

## Step 9: Apply to each — วนลูปทุก Demand Folder

**Action:** Control - Apply to each

| Setting | Value |
|---------|-------|
| Select an output from previous steps | `@{body('Filter_array')}` |

---

### Step 9a: Set Variable — varCurrentDemand (ภายใน Apply to each)

**Action:** Variables - Set variable

| Setting | Value |
|---------|-------|
| Name | varCurrentDemand |
| Value | *(Expression mode)* |

**Expression (กด fx แล้วใส่):**
```
{
  "folderId": items('Apply_to_each')?['Name'],
  "folderName": items('Apply_to_each')?['Name'],
  "folderUrl": items('Apply_to_each')?['{Link}'],
  "checklist": [],
  "totalItems": 0,
  "foundItems": 0,
  "missingItems": 0,
  "completionPercent": 0,
  "status": "Missing",
  "lastChecked": utcNow()
}
```

> ⚠️ ใช้ Compose action แทน Set variable ถ้าต้องการ nested JSON ที่ซับซ้อน

---

### Step 9b: Compose — Build folder info

**Action:** Data Operation - Compose

**Inputs:**
```json
{
  "folderId": "@{items('Apply_to_each')?['Name']}",
  "folderName": "@{items('Apply_to_each')?['Name']}",
  "folderUrl": "@{items('Apply_to_each')?['{Link}']}",
  "lastChecked": "@{utcNow()}"
}
```

---

### Step 9c: SharePoint — List folder (Get Files in Demand Folder)

**Action:** SharePoint - List folder

| Setting | Value |
|---------|-------|
| Site Address | `https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation` |
| File Identifier | *(Dynamic content)* |

**File Identifier Expression:**
```
@{concat('/Shared Documents/04_Digital Capability Center/Demand and Solution Management/Demand - Document/2026/', items('Apply_to_each')?['Name'])}
```

**Output:** Array ของไฟล์ทั้งหมดใน Demand folder นั้น

---

### Step 9d: Excel Online (Business) — List rows present in a table

**Action:** Excel Online (Business) - List rows present in a table

| Setting | Value |
|---------|-------|
| Location | SharePoint |
| Document Library | Shared Documents |
| File | Browse to: `04_Digital Capability Center/Demand and Solution Management/Demand - Document/2026/Development Transition Checklist/Checklist_Dev_AI.xlsx` |
| Table | (เลือก Table ที่มีข้อมูล Checklist) |

> 💡 **ต้องเลือก File ผ่าน File browser ไม่ใช่พิมพ์เอง**

---

### Step 9e: Initialize Variable — varChecklistResults (ก่อน nested loop)

**Action:** Variables - Initialize variable  
**(ต้องสร้าง ก่อน Apply to each ด้านนอก)**

| Setting | Value |
|---------|-------|
| Name | varChecklistResults |
| Type | Array |
| Value | `[]` |

> ⚠️ **สำคัญ:** ต้อง Set variable ให้เป็น `[]` ก่อนเข้า nested loop ทุกครั้ง

---

### Step 9f: Set Variable — Reset varChecklistResults (ภายใน Apply to each ด้านนอก)

**Action:** Variables - Set variable

| Setting | Value |
|---------|-------|
| Name | varChecklistResults |
| Value | `[]` |

---

### Step 9g: Apply to each (Nested) — วนลูปทุก Checklist Row

**Action:** Control - Apply to each

| Setting | Value |
|---------|-------|
| Select an output | `@{body('List_rows_present_in_a_table')?['value']}` |

---

#### Step 9g-i: Condition — ตรวจสอบ Finding Docs Name ไม่ใช่ N/A

**Action:** Control - Condition

**Condition (Advanced mode):**
```
@not(equals(toLower(trim(items('Apply_to_each_2')?['Finding Docs Name'])), 'n/a'))
```

---

#### Step 9g-ii (IF YES): Compose — Split Finding Docs Name by "/"

**Action:** Data Operation - Compose

**Inputs Expression:**
```
@split(items('Apply_to_each_2')?['Finding Docs Name'], '/')
```

---

#### Step 9g-iii (IF YES): Initialize/Set Variable — varFoundFile

**Action:** Variables - Set variable (ต้อง initialize ก่อน loop)

| Setting | Value |
|---------|-------|
| Name | varFoundFile |
| Value | `""` |

---

#### Step 9g-iv (IF YES): Apply to each — วนลูปทุก Keyword

**Action:** Control - Apply to each

| Setting | Value |
|---------|-------|
| Select an output | `@{outputs('Compose_Split_Keywords')}` |

---

##### Step 9g-iv-1: Filter Array — ค้นหาไฟล์ที่ match keyword

**Action:** Data Operation - Filter array

| Setting | Value |
|---------|-------|
| From | `@{body('List_folder_2')?['value']}` |

**Condition (Advanced mode):**
```
@contains(toLower(item()?['Name']), toLower(trim(items('Apply_to_each_keyword'))))
```

---

##### Step 9g-iv-2: Condition — ถ้าพบไฟล์ที่ match

**Action:** Control - Condition

**Condition:**
```
@greater(length(body('Filter_array_2')), 0)
```

**IF YES — Set Variable varFoundFile:**
```
@{first(body('Filter_array_2'))?['Name']}
```

---

#### Step 9g-v: Condition — ตรวจสอบว่าพบไฟล์หรือไม่

**Action:** Control - Condition

**Condition:**
```
@not(equals(variables('varFoundFile'), ''))
```

**IF YES (Found):**

**Compose — Checklist Item Result (Found):**
```json
{
  "checklistId": "@{items('Apply_to_each_2')?['Checklist ID']}",
  "item": "@{items('Apply_to_each_2')?['ITEM']}",
  "partyResponsible": "@{items('Apply_to_each_2')?['PARTY RESPONSIBLE']}",
  "mandatory": "@{equals(items('Apply_to_each_2')?['MANDATORY'], 'Y')}",
  "findingDocsName": "@{items('Apply_to_each_2')?['Finding Docs Name']}",
  "status": "Found",
  "matchedFile": "@{variables('varFoundFile')}",
  "updatedBy": "Power Automate",
  "lastUpdate": "@{utcNow()}"
}
```

**IF NO (Missing):**

**Compose — Checklist Item Result (Missing):**
```json
{
  "checklistId": "@{items('Apply_to_each_2')?['Checklist ID']}",
  "item": "@{items('Apply_to_each_2')?['ITEM']}",
  "partyResponsible": "@{items('Apply_to_each_2')?['PARTY RESPONSIBLE']}",
  "mandatory": "@{equals(items('Apply_to_each_2')?['MANDATORY'], 'Y')}",
  "findingDocsName": "@{items('Apply_to_each_2')?['Finding Docs Name']}",
  "status": "Missing",
  "matchedFile": null,
  "updatedBy": "Power Automate",
  "lastUpdate": "@{utcNow()}"
}
```

---

#### Step 9g-vi: Append to array variable — varChecklistResults

**Action:** Variables - Append to array variable

| Setting | Value |
|---------|-------|
| Name | varChecklistResults |
| Value | `@{outputs('Compose_Found')}` หรือ `@{outputs('Compose_Missing')}` |

---

### Step 9h: Compose — Calculate Completion Statistics

**Action:** Data Operation - Compose

**Inputs Expression:**
```
@{
  json(
    concat(
      '{"folderId":"', outputs('Compose_FolderInfo')?['folderId'],
      '","folderName":"', outputs('Compose_FolderInfo')?['folderName'],
      '","folderUrl":"', outputs('Compose_FolderInfo')?['folderUrl'],
      '","totalItems":', string(length(variables('varChecklistResults'))),
      ',"foundItems":', string(length(filter(variables('varChecklistResults'), item => item['status'] == 'Found'))),
      ',"checklist":', string(variables('varChecklistResults')),
      '}'
    )
  )
}
```

> 💡 **Alternative:** ใช้ multiple Compose actions แยกกัน แล้วรวมกันตอนสุดท้าย

---

### Step 9i: Append to array variable — varResults

**Action:** Variables - Append to array variable

| Setting | Value |
|---------|-------|
| Name | varResults |
| Value | `@{outputs('Compose_DemandResult')}` |

---

## Step 10: Compose — Build Final JSON

**Action:** Data Operation - Compose

**Inputs Expression:**
```json
{
  "metadata": {
    "lastChecked": "@{addHours(utcNow(), 7)}",
    "nextScheduled": "@{addHours(addDays(utcNow(), 1), 7)}",
    "flowName": "Transition Checklist Scanner",
    "sharePointSite": "https://banpugroup.sharepoint.com/sites/Internal_Digital_Innovation",
    "demandFolderPath": "/Shared Documents/04_Digital Capability Center/Demand and Solution Management/Demand - Document/2026",
    "checklistFile": "Checklist_Dev_AI.xlsx",
    "totalDemandsScanned": "@{length(variables('varResults'))}",
    "scanDurationSeconds": "@{div(sub(ticks(utcNow()), ticks(variables('varStartTime'))), 10000000)}"
  },
  "demands": "@{variables('varResults')}"
}
```

---

## Step 11: OneDrive — Create or Update File (dashboard_data.json)

**Action:** OneDrive for Business - Create file  
*(ถ้า file มีอยู่แล้ว ให้ใช้ "Update file content" แทน หรือจัดการด้วย Condition)*

| Setting | Value |
|---------|-------|
| Folder Path | `/Claude/Transition Checklist` |
| File Name | `dashboard_data.json` |
| File Content | `@{outputs('Compose_Final_JSON')}` |

> 💡 **วิธีจัดการถ้า file มีอยู่แล้ว:**
> 1. ลองใช้ "Create file" — ถ้า error ค่อยใช้ "Update file content"
> 2. หรือใช้ Scope + Configure run after เพื่อ fallback

---

## Step 12: Terminate — Success

**Action:** Control - Terminate

| Setting | Value |
|---------|-------|
| Status | Succeeded |
| Message | `Scan completed. @{length(variables('varResults'))} demands processed.` |

---

## การจัดการ Error (Error Handling)

### วิธีที่ 1: Try-Catch Pattern

1. เพิ่ม **Scope** action ครอบทุก step
2. ใส่ **Terminate (Failed)** action ข้างนอก Scope
3. Configure run after → Set condition ให้ run เมื่อ Scope failed

### วิธีที่ 2: Configure run after

บน action สำคัญ คลิก `...` > **Configure run after** > ติ๊ก:
- ✅ is successful
- ✅ has failed  
- ✅ is skipped

---

## Expressions ที่สำคัญ (Quick Reference)

| Use Case | Expression |
|----------|-----------|
| ตรวจสอบ folder name starts with "Demand" | `@startsWith(item()?['Name'], 'Demand')` |
| Split keyword by "/" | `@split(item()?['Finding Docs Name'], '/')` |
| Trim whitespace | `@trim(item())` |
| Case-insensitive contains | `@contains(toLower(item()?['Name']), toLower(trim(items('loop'))))` |
| Get first match | `@first(body('Filter_array'))` |
| Check array is not empty | `@greater(length(body('Filter_array')), 0)` |
| Current time + 7h (Bangkok) | `@addHours(utcNow(), 7)` |
| Build JSON string | `@json(concat('{...}'))` |
| Count found items | `@length(filter(variables('arr'), item => item['status'] == 'Found'))` |

---

## การ Test Flow

### Manual Run:
1. บน Flow designer คลิก **"Test"** (มุมบนขวา)
2. เลือก **"Manually"**
3. คลิก **"Test"** > **"Run flow"**
4. รอดู results ใน Run History

### ตรวจสอบ Output:
1. คลิก **"Flow runs"** ใน left sidebar
2. คลิก run ล่าสุด
3. Expand แต่ละ action เพื่อดู inputs/outputs

### Debug Tips:
- ถ้า "List folder" return empty → ตรวจสอบ path ให้ถูกต้อง (ไม่ต้องมี trailing slash)
- ถ้า "Filter array" return 0 items → ตรวจสอบ folder name patterns
- ถ้า Excel action fail → ตรวจสอบว่า table ใน Excel มีชื่อ (ไม่ใช่แค่ range)

---

## Notes สำคัญ

1. **Excel Table:** ไฟล์ Checklist_Dev_AI.xlsx ต้องมีข้อมูลในรูปแบบ Excel Table (ไม่ใช่แค่ range) — ใน Excel ให้ select data แล้ว Insert > Table

2. **OneDrive Folder:** สร้างโฟลเดอร์ `/Claude/Transition Checklist/` ใน OneDrive ก่อน

3. **Permissions:** ต้องมีสิทธิ์ Read ที่ SharePoint site และ Write ที่ OneDrive

4. **Run Frequency:** Flow ทำงานทุกวัน — ตรวจสอบ Power Automate quota (standard users มี ~5,000 runs/month)

5. **Nested Loops:** Power Automate มี limit ที่ nested apply-to-each ลึกได้ 2 ระดับเท่านั้น — ออกแบบให้ flat ที่สุด

---

## ตัวอย่าง JSON Output ที่ได้

```json
{
  "metadata": {
    "lastChecked": "2026-04-10T10:30:00+07:00",
    "nextScheduled": "2026-04-11T08:00:00+07:00",
    "flowName": "Transition Checklist Scanner",
    "totalDemandsScanned": 12
  },
  "demands": [
    {
      "folderId": "Demand - DMND0007240",
      "folderName": "Demand - DMND0007240",
      "totalItems": 6,
      "foundItems": 2,
      "checklist": [...]
    }
  ]
}
```

---

*สร้างโดย: Digital Capability Center | อัปเดต: เมษายน 2026*
