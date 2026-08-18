# Reflection

Nhóm tôi dễ vướng nhất anti-pattern **coi VACUUM hoặc snapshot expiry là một
quy trình dọn dẹp hoàn chỉnh**. Khi pipeline vừa có Delta cho dữ liệu vận hành
vừa có Iceberg cho catalogue/training, mỗi công cụ chỉ thấy metadata mà nó quản
lý: Delta VACUUM không thấy file orphan chưa từng commit, còn Iceberg snapshot
expiry chủ yếu dọn metadata và có thể để lại manifest/file không còn được tham
chiếu. Nếu chỉ nhìn số snapshot giảm hoặc job “success”, chi phí object storage
vẫn tăng và dữ liệu nhạy cảm có thể tồn tại lâu hơn retention policy. Vì vậy đội
phải đo tập file thực tế trước/sau, quét orphan độc lập, ghi audit log cho xoá,
và tách job expiry khỏi job physical cleanup. Với corpus AI, cần kết hợp các job
đó với provenance/retention theo license để việc xoá có thể chứng minh được.
