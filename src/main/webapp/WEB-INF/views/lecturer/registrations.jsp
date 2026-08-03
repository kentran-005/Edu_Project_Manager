<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ include file="../common/header.jsp" %>

		<!-- Page Header & Action Controls -->
		<div class="page-header-row">
			<div class="page-title-box">
				<h1>Duyệt đăng ký đề tài</h1>
				<p>Xem và duyệt các nhóm sinh viên đăng ký thực hiện đề tài</p>
			</div>
			<div class="page-header-actions">
				<div class="search-box">
					<span class="search-icon">🔍</span>
					<input type="text" id="searchInput" placeholder="Tìm kiếm đề tài, nhóm, sinh viên..."
						onkeyup="filterRegistrations()">
				</div>
				<button type="button" class="btn-filter" onclick="resetFilters()">🌪 Bộ lọc</button>
				<button type="button" class="btn-filter" title="Chọn ngày">📅</button>
			</div>
		</div>

		<!-- 4 Stats Cards Grid -->
		<div class="reg-stats-grid">
			<!-- Card 1: Tổng đăng ký -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon blue">📄</div>
					<div class="stat-card-info">
						<label>Tổng đăng ký</label>
						<strong>${not empty stats.total_registrations ? stats.total_registrations :
							fn:length(registrations)}</strong>
						<span class="stat-card-sub">Tất cả đăng ký</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('ALL')">Xem chi tiết →</span>
			</div>

			<!-- Card 2: Chờ duyệt -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon green">✓</div>
					<div class="stat-card-info">
						<label>Chờ duyệt</label>
						<strong>${not empty stats.pending_registrations ? stats.pending_registrations : 0}</strong>
						<span class="stat-card-sub">Đang chờ xử lý</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('PENDING')">Xem chi tiết →</span>
			</div>

			<!-- Card 3: Đã duyệt -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon orange">✓</div>
					<div class="stat-card-info">
						<label>Đã duyệt</label>
						<strong>${not empty stats.approved_registrations ? stats.approved_registrations : 0}</strong>
						<span class="stat-card-sub">Đã chấp thuận</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('APPROVED')">Xem chi tiết →</span>
			</div>

			<!-- Card 4: Từ chối -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon red">✕</div>
					<div class="stat-card-info">
						<label>Từ chối</label>
						<strong>${not empty stats.rejected_registrations ? stats.rejected_registrations : 0}</strong>
						<span class="stat-card-sub">Không chấp thuận</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('REJECTED')">Xem chi tiết →</span>
			</div>
		</div>

		<!-- Table "Danh sách đăng ký chờ duyệt" -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>Danh sách đăng ký chờ duyệt</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table" id="regTable">
					<thead>
						<tr>
							<th style="width:40px;text-align:center"><input type="checkbox"
									onchange="toggleSelectAll(this)"></th>
							<th style="width:50px">#</th>
							<th style="width:130px">Mã đề tài</th>
							<th>Tên đề tài</th>
							<th style="width:130px">Nhóm</th>
							<th style="width:90px">Sinh viên</th>
							<th style="width:120px">Ngày đăng ký</th>
							<th style="width:130px">Trạng thái</th>
							<th style="width:140px;text-align:center">Thao tác</th>
						</tr>
					</thead>
					<tbody id="regTbody">
						<c:choose>
							<c:when test="${empty registrations}">
								<tr>
									<td colspan="9" class="table-empty">Hiện tại chưa có yêu cầu đăng ký đề tài nào.
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="r" items="${registrations}" varStatus="loop">
									<tr class="reg-row" data-status="${r.status}"
										data-group="${fn:toLowerCase(r.group_name)}"
										data-title="${fn:toLowerCase(r.topic_title)}"
										data-code="DT2024_00${r.topic_id}">
										<td style="text-align:center"><input type="checkbox" class="row-chk"></td>
										<td>${loop.index + 1}</td>
										<td>
											<span class="topic-code-tag">DT2024_00${r.topic_id}</span>
										</td>
										<td>
											<div class="topic-title-cell" title="${r.topic_title}">${r.topic_title}
											</div>
										</td>
										<td>${r.group_name}</td>
										<td>${not empty r.member_count && r.member_count > 0 ? r.member_count : 4}</td>
										<td>
											<c:set var="cdate" value="${fn:substring(r.created_at,0,10)}" />
											${not empty cdate ? cdate : '12/02/2024'}
										</td>
										<td>
											<c:choose>
												<c:when test="${r.status=='PENDING'}">
													<span class="status-pill orange">Chờ duyệt</span>
												</c:when>
												<c:when test="${r.status=='APPROVED'}">
													<span class="status-pill green">Đã duyệt</span>
												</c:when>
												<c:when test="${r.status=='REJECTED'}">
													<span class="status-pill red">Từ chối</span>
												</c:when>
												<c:otherwise>
													<span class="status-pill orange">Chờ duyệt</span>
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<div class="row-actions" style="justify-content:center">
												<button type="button" class="btn-icon-act view"
													title="Xem chi tiết đăng ký"
													onclick="openViewRegModal('${r.id}', 'DT2024_00${r.topic_id}', '${fn:escapeXml(r.topic_title)}', '${fn:escapeXml(r.group_name)}', '${r.member_count}', '${r.status}', '${fn:escapeXml(r.note)}')">
													👁
												</button>
												<c:choose>
													<c:when test="${r.status=='PENDING'}">
														<button type="button" class="btn-act-approve"
															title="Duyệt đăng ký"
															onclick="openReviewModal('${r.id}', '${fn:escapeXml(r.group_name)}', '${fn:escapeXml(r.topic_title)}', 'APPROVED')">
															✓
														</button>
														<button type="button" class="btn-act-reject"
															title="Từ chối đăng ký"
															onclick="openReviewModal('${r.id}', '${fn:escapeXml(r.group_name)}', '${fn:escapeXml(r.topic_title)}', 'REJECTED')">
															✕
														</button>
													</c:when>
													<c:otherwise>
														<button type="button" class="btn-act-approve"
															style="opacity:0.4;cursor:not-allowed" disabled>✓</button>
														<button type="button" class="btn-act-reject"
															style="opacity:0.4;cursor:not-allowed" disabled>✕</button>
													</c:otherwise>
												</c:choose>
											</div>
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<!-- Pagination Footer -->
			<div class="table-pagination-bar">
				<div class="pagination-info" id="paginationInfo">
					Hiển thị <span id="showingCount">1 đến ${fn:length(registrations) > 10 ? 10 :
						fn:length(registrations)}</span> trong tổng số <strong>${fn:length(registrations)}</strong> đăng
					ký
				</div>
				<div class="pagination-controls">
					<select class="rows-per-page-select">
						<option value="10" selected>10 / trang</option>
						<option value="20">20 / trang</option>
						<option value="50">50 / trang</option>
					</select>
					<div class="page-btn-group">
						<button type="button" class="page-num-btn">&lt;</button>
						<button type="button" class="page-num-btn active">1</button>
						<button type="button" class="page-num-btn">&gt;</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Modal 1: Review Action Modal (Approve / Reject) -->
		<div class="custom-modal" id="reviewModal">
			<div class="modal-container" style="max-width:520px">
				<div class="modal-header-custom">
					<h2 id="reviewModalTitle">Phê duyệt đăng ký</h2>
					<button type="button" class="modal-close-btn" onclick="closeModal('reviewModal')">&times;</button>
				</div>
				<form method="post" action="${pageContext.request.contextPath}/lecturer/registrations">
					<input type="hidden" name="id" id="reviewRegId">
					<input type="hidden" name="status" id="reviewRegStatus">
					<div class="modal-body-custom">
						<div
							style="background:#f8fafc;padding:14px;border-radius:12px;margin-bottom:16px;font-size:13.5px">
							<p style="margin:0 0 6px"><strong>Nhóm:</strong> <span id="reviewGroupName">--</span></p>
							<p style="margin:0"><strong>Đề tài:</strong> <span id="reviewTopicTitle">--</span></p>
						</div>
						<label>Ghi chú / Phản hồi cho sinh viên:</label>
						<textarea name="note" id="reviewNote"
							placeholder="Nhập lý do duyệt hoặc từ chối đề tài..."></textarea>
					</div>
					<div class="modal-footer-custom">
						<button type="button" class="btn-secondary-custom"
							onclick="closeModal('reviewModal')">Hủy</button>
						<button type="submit" class="btn-add-primary" id="reviewSubmitBtn">Xác nhận</button>
					</div>
				</form>
			</div>
		</div>

		<!-- Modal 2: View Registration Detail Modal -->
		<div class="custom-modal" id="viewRegModal">
			<div class="modal-container">
				<div class="modal-header-custom">
					<h2>👁 Chi tiết đăng ký đề tài</h2>
					<button type="button" class="modal-close-btn" onclick="closeModal('viewRegModal')">&times;</button>
				</div>
				<div class="modal-body-custom">
					<div style="margin-bottom:16px">
						<span class="topic-code-tag" id="viewRegCode">DT2024_001</span>
						<h3 id="viewRegTopic" style="margin:8px 0 4px;font-size:18px;color:#0f172a">Tên đề tài</h3>
						<span id="viewRegStatusBadge"></span>
					</div>
					<div class="row" style="margin-bottom:16px;background:#f8fafc;padding:16px;border-radius:12px">
						<div>
							<small style="color:#64748b;display:block">Nhóm thực hiện</small>
							<strong id="viewRegGroup" style="color:#0f172a">--</strong>
						</div>
						<div>
							<small style="color:#64748b;display:block">Số thành viên</small>
							<strong id="viewRegMembers" style="color:#0f172a">--</strong>
						</div>
					</div>
					<div style="margin-bottom:16px">
						<label style="color:#475569">Ghi chú từ nhóm sinh viên:</label>
						<div id="viewRegNote"
							style="background:#f8fafc;padding:12px;border-radius:10px;font-size:14px;white-space:pre-wrap">
							--</div>
					</div>
				</div>
				<div class="modal-footer-custom">
					<button type="button" class="btn-secondary-custom"
						onclick="closeModal('viewRegModal')">Đóng</button>
				</div>
			</div>
		</div>

		<!-- Client-side Filtering & Modal Script -->
		<script>
			function openReviewModal(regId, groupName, topicTitle, status) {
				document.getElementById('reviewRegId').value = regId;
				document.getElementById('reviewRegStatus').value = status;
				document.getElementById('reviewGroupName').innerText = groupName;
				document.getElementById('reviewTopicTitle').innerText = topicTitle;
				document.getElementById('reviewNote').value = '';

				var titleElem = document.getElementById('reviewModalTitle');
				var btnElem = document.getElementById('reviewSubmitBtn');

				if (status === 'APPROVED') {
					titleElem.innerText = '✓ Xác nhận Duyệt đăng ký';
					titleElem.style.color = '#15803d';
					btnElem.innerText = 'Xác nhận Duyệt';
					btnElem.style.background = '#16a34a';
				} else {
					titleElem.innerText = '✕ Xác nhận Từ chối đăng ký';
					titleElem.style.color = '#dc2626';
					btnElem.innerText = 'Xác nhận Từ chối';
					btnElem.style.background = '#dc2626';
				}
				document.getElementById('reviewModal').classList.add('show');
			}

			function openViewRegModal(id, topicCode, topicTitle, groupName, memberCount, status, note) {
				document.getElementById('viewRegCode').innerText = topicCode;
				document.getElementById('viewRegTopic').innerText = topicTitle;
				document.getElementById('viewRegGroup').innerText = groupName;
				document.getElementById('viewRegMembers').innerText = memberCount + ' sinh viên';
				document.getElementById('viewRegNote').innerText = note || 'Không có ghi chú thêm từ sinh viên.';

				var badgeHtml = '<span class="status-pill orange">Chờ duyệt</span>';
				if (status === 'APPROVED') badgeHtml = '<span class="status-pill green">Đã duyệt</span>';
				else if (status === 'REJECTED') badgeHtml = '<span class="status-pill red">Từ chối</span>';
				document.getElementById('viewRegStatusBadge').innerHTML = badgeHtml;

				document.getElementById('viewRegModal').classList.add('show');
			}

			function closeModal(modalId) {
				document.getElementById(modalId).classList.remove('show');
			}

			function filterRegistrations() {
				var query = document.getElementById('searchInput').value.toLowerCase();
				var rows = document.querySelectorAll('.reg-row');
				var visibleCount = 0;

				rows.forEach(function (row) {
					var title = row.getAttribute('data-title') || '';
					var group = row.getAttribute('data-group') || '';
					var code = row.getAttribute('data-code') || '';
					if (title.indexOf(query) !== -1 || group.indexOf(query) !== -1 || code.toLowerCase().indexOf(query) !== -1) {
						row.style.display = '';
						visibleCount++;
					} else {
						row.style.display = 'none';
					}
				});

				document.getElementById('showingCount').innerText = '1 đến ' + (visibleCount > 10 ? 10 : visibleCount);
			}

			function filterByStatus(statusKey) {
				var rows = document.querySelectorAll('.reg-row');
				rows.forEach(function (row) {
					var st = row.getAttribute('data-status');
					if (statusKey === 'ALL') {
						row.style.display = '';
					} else if (st === statusKey) {
						row.style.display = '';
					} else {
						row.style.display = 'none';
					}
				});
			}

			function resetFilters() {
				document.getElementById('searchInput').value = '';
				filterByStatus('ALL');
			}

			function toggleSelectAll(master) {
				document.querySelectorAll('.row-chk').forEach(function (chk) {
					chk.checked = master.checked;
				});
			}
		</script>

		<%@ include file="../common/footer.jsp" %>