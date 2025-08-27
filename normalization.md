## 1NF:
- All the entities meet 1NF.
## 2NF:
- All the entities meet 2NF.
## 3NF:
- All the entities meet 3NF.
- There might be some issue and need to be normalized, but I prefer to keep the denormalized version.
- The issue is on total_price attribute of Booking entity. Since it is drived value from Property's pricepernight and Booking's start_date, and end_date, it is not directly dependent on booking_id, but it works fine. Because it is stored and not updated after once calculated and it will fully and directly dependent on the primary key of Booking (booking_id).

---
There for all the entities are normalized upto 3NF.