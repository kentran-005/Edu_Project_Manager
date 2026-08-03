<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/header.jsp" %>

<!-- Page Header -->
<div class="page-header-row" style="margin-bottom: 20px;">
	<div class="page-title-box">
		<h1>Hướng dẫn sử dụng & Trung tâm hỗ trợ</h1>
		<p style="font-size: 13px; color: #64748b; margin-top: 2px;">Trang chủ &gt; Hướng dẫn & Hỗ trợ</p>
	</div>
</div>

<!-- Support Grid: FAQs Left & Contact Form Right -->
<div class="row" style="grid-template-columns: 1.6fr 1fr; gap: 20px; align-items: start;">
	
	<!-- FAQs Section -->
	<div class="admin-panel" style="border-radius: 16px; padding: 22px;">
		<h3 style="margin: 0 0 16px; font-size: 17px; font-weight: 800; color: #0f172a;">Câu hỏi thường gặp (FAQ)</h3>

		<details style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:12px 16px; margin-bottom:12px; cursor:pointer;" open>
			<summary style="font-weight:700; color:#1d4ed8; font-size:14px;">1. Làm thế nào để tạo nhóm và mời các bạn khác vào nhóm?</summary>
			<p style="margin:8px 0 0; font-size:13px; color:#475569; line-height:1.5;">
				Truy cập mục <b>"Nhóm của tôi"</b>, chọn Tab <b>"Tạo nhóm"</b> và điền Tên nhóm, Học kỳ. Sau khi tạo thành viên sẽ trở thành Trưởng nhóm và nhận được một <b>Mã mời nhóm (Invite Code)</b>. Gửi mã mời này cho các bạn khác nhập vào Tab <b>"Tham gia nhóm"</b>.
			</p>
		</details>

		<details style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:12px 16px; margin-bottom:12px; cursor:pointer;">
			<summary style="font-weight:700; color:#1d4ed8; font-size:14px;">2. Cách nộp báo cáo tiến độ tuần và bài nộp Cloudinary?</summary>
			<p style="margin:8px 0 0; font-size:13px; color:#475569; line-height:1.5;">
				Nhấp vào <b>"Xem tiến độ"</b> tại nhóm của bạn. Chọn form <b>"Nộp báo cáo tiến độ"</b> để ghi nhận công việc tuần, hoặc chọn form <b>"Upload tài liệu / Source code"</b> để tải tệp PDF/ZIP trực tiếp lên lưu trữ Cloudinary.
			</p>
		</details>

		<details style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:12px 16px; margin-bottom:12px; cursor:pointer;">
			<summary style="font-weight:700; color:#1d4ed8; font-size:14px;">3. Sinh viên có thể đổi đề tài sau khi đã đăng ký không?</summary>
			<p style="margin:8px 0 0; font-size:13px; color:#475569; line-height:1.5;">
				Khi đề tài ở trạng thái <i>Chờ duyệt</i>, Trưởng nhóm có thể chọn đăng ký lại đề tài khác. Nếu đề tài đã được Giảng viên phê duyệt <i>Đang thực hiện</i>, vui lòng liên hệ trực tiếp Giảng viên hướng dẫn để được hỗ trợ thay đổi.
			</p>
		</details>
	</div>

	<!-- Contact / Support Form -->
	<div class="admin-panel" style="border-radius: 16px; padding: 22px;">
		<h3 style="margin: 0 0 14px; font-size: 17px; font-weight: 800; color: #0f172a;">Liên hệ hỗ trợ kỹ thuật</h3>

		<div style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:10px; padding:12px; margin-bottom:16px; font-size:12.5px; color:#1e40af;">
			<b>☎ Hotline Đào tạo:</b> (024) 7300 1886<br>
			<b>✉ Email hỗ trợ:</b> hotro.dpm@poly.edu.vn
		</div>

		<form onsubmit="event.preventDefault(); alert('Cảm ơn bạn! Yêu cầu hỗ trợ đã được gửi tới Ban quản trị hệ thống.');">
			<label style="font-size:12px;">Chủ đề cần hỗ trợ</label>
			<select style="margin-bottom:8px; padding:8px 10px;">
				<option>Lỗi tài khoản / Phân quyền</option>
				<option>Lỗi nộp báo cáo / Upload Cloudinary</option>
				<option>Thắc mắc Đăng ký đề tài</option>
				<option>Góp ý hệ thống</option>
			</select>

			<label style="font-size:12px;">Nội dung chi tiết</label>
			<textarea placeholder="Mô tả sự cố hoặc thắc mắc của bạn..." required style="min-height:80px; margin-bottom:14px; padding:8px; font-size:13px;"></textarea>

			<button type="submit" class="btn-add-primary" style="width:100%; justify-center; font-size:13px;">Gửi yêu cầu hỗ trợ</button>
		</form>
	</div>

</div>

<%@ include file="../common/footer.jsp" %>
