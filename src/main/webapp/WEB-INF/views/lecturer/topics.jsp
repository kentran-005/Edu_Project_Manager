<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ include file="../common/header.jsp" %>

		<!-- Page Header & Action Controls -->
		<div class="page-header-row">
			<div class="page-title-box">
				<h1>Đề tài của tôi</h1>
				<p>Quản lý và theo dõi các đề tài đồ án bạn tạo hoặc phụ trách hướng dẫn</p>
			</div>
			<div class="page-header-actions">
				<div class="search-box">
					<span class="search-icon">🔍</span>
					<input type="text" id="searchInput" placeholder="Tìm kiếm đề tài..." onkeyup="filterTopics()">
				</div>
				<button type="button" class="btn-filter" onclick="resetFilters()">🌪 Bộ lọc</button>
				<c:choose>
					<c:when test="${empty semesters}">
						<button type="button" class="btn-add-primary" disabled
							title="Cần có học kỳ trước khi tạo đề tài">+ Thêm đề tài</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn-add-primary" onclick="openAddModal()">+ Thêm đề tài</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<c:if test="${empty semesters}">
			<div class="error">
				Chưa có học kỳ nào trong hệ thống. Vui lòng nhờ Quản trị viên khởi tạo học kỳ trước khi tạo đề tài mới.
			</div>
		</c:if>

		<!-- 5 Stats Cards Grid -->
		<div class="topic-stats-grid">
			<!-- Card 1: Tổng đề tài -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon blue">📄</div>
					<div class="stat-card-info">
						<label>Tổng đề tài</label>
						<strong>${not empty stats.total_topics ? stats.total_topics : fn:length(topics)}</strong>
						<span class="stat-card-sub">Tất cả đề tài</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('ALL')">Xem chi tiết →</span>
			</div>

			<!-- Card 2: Đang hướng dẫn -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon green">👥</div>
					<div class="stat-card-info">
						<label>Đang hướng dẫn</label>
						<strong>${not empty stats.in_progress_topics ? stats.in_progress_topics : 0}</strong>
						<span class="stat-card-sub">Đang thực hiện</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('OPEN')">Xem chi tiết →</span>
			</div>

			<!-- Card 3: Chờ duyệt -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon orange">📋</div>
					<div class="stat-card-info">
						<label>Chờ duyệt</label>
						<strong>${not empty stats.pending_topics ? stats.pending_topics : 0}</strong>
						<span class="stat-card-sub">Chờ phê duyệt</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('DRAFT')">Xem chi tiết →</span>
			</div>

			<!-- Card 4: Hoàn thành -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon purple">💬</div>
					<div class="stat-card-info">
						<label>Hoàn thành</label>
						<strong>${not empty stats.completed_topics ? stats.completed_topics : 0}</strong>
						<span class="stat-card-sub">Đã bảo vệ</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('CLOSED')">Xem chi tiết →</span>
			</div>

			<!-- Card 5: Đánh giá tốt -->
			<div class="topic-stat-card">
				<div class="stat-card-top">
					<div class="stat-card-icon cyan">⭐</div>
					<div class="stat-card-info">
						<label>Đánh giá tốt</label>
						<strong>${not empty stats.good_topics ? stats.good_topics : 0}</strong>
						<span class="stat-card-sub">Điểm TB ≥ 8.0</span>
					</div>
				</div>
				<span class="stat-card-link" onclick="filterByStatus('GOOD')">Xem chi tiết →</span>
			</div>
		</div>

		<!-- Table "Danh sách đề tài" -->
		<div class="topic-table-card">
			<div class="card-title-head">
				<h3>Danh sách đề tài</h3>
			</div>
			<div class="table-responsive">
				<table class="topic-data-table" id="topicsTable">
					<thead>
						<tr>
							<th style="width:50px">#</th>
							<th style="width:130px">Mã đề tài</th>
							<th>Tên đề tài</th>
							<th style="width:120px">Nhóm</th>
							<th style="width:100px">Sinh viên</th>
							<th style="width:140px">Trạng thái</th>
							<th style="width:120px">Ngày tạo</th>
							<th style="width:120px;text-align:center">Hành động</th>
						</tr>
					</thead>
					<tbody id="topicsTbody">
						<c:choose>
							<c:when test="${empty topics}">
								<tr>
									<td colspan="8" class="table-empty">Chưa có đề tài nào. Nhấn "+ Thêm đề tài" để tạo
										mới.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="t" items="${topics}" varStatus="loop">
									<tr class="topic-row" data-status="${t.status}"
										data-title="${fn:toLowerCase(t.title)}"
										data-tech="${fn:toLowerCase(t.technology)}" data-code="DT2024_00${t.id}">
										<td>${loop.index + 1}</td>
										<td>
											<span class="topic-code-tag">DT2024_00${t.id}</span>
										</td>
										<td>
											<div class="topic-title-cell" title="${t.title}">${t.title}</div>
										</td>
										<td>${not empty t.group_name ? t.group_name : 'Nhóm '}${not empty t.group_id ?
											t.group_id : (loop.index + 1)}</td>
										<td>${not empty t.member_count && t.member_count > 0 ? t.member_count :
											t.max_members}</td>
										<td>
											<c:choose>
												<c:when test="${t.status=='OPEN'}">
													<span class="status-pill green">Đang thực hiện</span>
												</c:when>
												<c:when test="${t.status=='DRAFT'}">
													<span class="status-pill orange">Chờ duyệt</span>
												</c:when>
												<c:when test="${t.status=='CLOSED'}">
													<span class="status-pill purple">Hoàn thành</span>
												</c:when>
												<c:otherwise>
													<span class="status-pill green">Đang thực hiện</span>
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:set var="cdate" value="${fn:substring(t.created_at,0,10)}" />
											${not empty cdate ? cdate : '12/02/2024'}
										</td>
										<td>
											<div class="row-actions" style="justify-content:center">
												<button type="button" class="btn-icon-act view" title="Xem chi tiết" 
													onclick="openViewModal('${t.id}', '${fn:escapeXml(t.title)}', '${fn:escapeXml(t.description)}', '${fn:escapeXml(t.requirements)}', '${fn:escapeXml(t.technology)}', '${t.max_members}', '${t.semester_name}', '${t.status}')">
													👁
												</button>
												<c:if test="${t.status != 'ASSIGNED'}">
													<button type="button" class="btn-icon-act edit" title="Chỉnh sửa" 
														onclick="openEditModal('${t.id}', '${fn:escapeXml(t.title)}', '${fn:escapeXml(t.description)}', '${fn:escapeXml(t.requirements)}', '${fn:escapeXml(t.technology)}', '${t.max_members}', '${t.status}')">
														✏
													</button>
												</c:if>
												<div class="action-dropdown-wrap">
													<button type="button" class="btn-icon-act" title="Tùy chọn" onclick="toggleActionMenu(event, 'menu_${t.id}')">⋮</button>
													<div class="action-dropdown-menu" id="menu_${t.id}">
														<button type="button" class="action-dropdown-item" onclick="openViewModal('${t.id}', '${fn:escapeXml(t.title)}', '${fn:escapeXml(t.description)}', '${fn:escapeXml(t.requirements)}', '${fn:escapeXml(t.technology)}', '${t.max_members}', '${t.semester_name}', '${t.status}')">
															👁 Xem chi tiết
														</button>
														<c:if test="${t.status != 'ASSIGNED'}">
															<button type="button" class="action-dropdown-item" onclick="openEditModal('${t.id}', '${fn:escapeXml(t.title)}', '${fn:escapeXml(t.description)}', '${fn:escapeXml(t.requirements)}', '${fn:escapeXml(t.technology)}', '${t.max_members}', '${t.status}')">
																✏ Chỉnh sửa
															</button>
															<div class="action-dropdown-divider"></div>
															<c:if test="${t.status != 'OPEN'}">
																<form method="post" action="${pageContext.request.contextPath}/topics" style="margin:0">
																	<input type="hidden" name="action" value="changeStatus">
																	<input type="hidden" name="id" value="${t.id}">
																	<input type="hidden" name="status" value="OPEN">
																	<button type="submit" class="action-dropdown-item">🟢 Chuyển Đang thực hiện</button>
																</form>
															</c:if>
															<c:if test="${t.status != 'DRAFT'}">
																<form method="post" action="${pageContext.request.contextPath}/topics" style="margin:0">
																	<input type="hidden" name="action" value="changeStatus">
																	<input type="hidden" name="id" value="${t.id}">
																	<input type="hidden" name="status" value="DRAFT">
																	<button type="submit" class="action-dropdown-item">🟠 Chuyển Chờ duyệt</button>
																</form>
															</c:if>
															<c:if test="${t.status != 'CLOSED'}">
																<form method="post" action="${pageContext.request.contextPath}/topics" style="margin:0">
																	<input type="hidden" name="action" value="changeStatus">
																	<input type="hidden" name="id" value="${t.id}">
																	<input type="hidden" name="status" value="CLOSED">
																	<button type="submit" class="action-dropdown-item">🟣 Chuyển Hoàn thành</button>
																</form>
															</c:if>
															<div class="action-dropdown-divider"></div>
															<form method="post" action="${pageContext.request.contextPath}/topics" style="margin:0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa đề tài này không?')">
																<input type="hidden" name="action" value="delete">
																<input type="hidden" name="id" value="${t.id}">
																<button type="submit" class="action-dropdown-item danger">🗑 Xóa đề tài</button>
															</form>
														</c:if>
													</div>
												</div>
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
					Hiển thị <span id="showingCount">1 đến ${fn:length(topics) > 10 ? 10 : fn:length(topics)}</span>
					trong tổng số <strong>${fn:length(topics)}</strong> đề tài
				</div>
				<div class="pagination-controls">
					<select class="rows-per-page-select" onchange="changeRowsPerPage(this.value)">
						<option value="10" selected>10 / trang</option>
						<option value="20">20 / trang</option>
						<option value="50">50 / trang</option>
					</select>
					<div class="page-btn-group">
						<button type="button" class="page-num-btn" onclick="prevPage()">&lt;</button>
						<button type="button" class="page-num-btn active">1</button>
						<button type="button" class="page-num-btn" onclick="nextPage()">&gt;</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Modal 1: Add Topic Modal -->
		<div class="custom-modal" id="addTopicModal">
			<div class="modal-container">
				<div class="modal-header-custom">
					<h2>+ Thêm đề tài mới</h2>
					<button type="button" class="modal-close-btn" onclick="closeModal('addTopicModal')">&times;</button>
				</div>
				<form method="post" action="${pageContext.request.contextPath}/topics">
					<div class="modal-body-custom">
						<div class="row">
							<div>
								<label>Tiêu đề đề tài <span style="color:red">*</span></label>
								<input type="text" name="title" required placeholder="Nhập tên đề tài đồ án...">

								<label>Mô tả chi tiết <span style="color:red">*</span></label>
								<textarea name="description" required placeholder="Mô tả nội dung đồ án..."></textarea>

								<label>Yêu cầu đề tài</label>
								<textarea name="requirements" placeholder="Các kiến thức/kỹ năng cần có..."></textarea>
							</div>
							<div>
								<label>Công nghệ sử dụng</label>
								<input type="text" name="technology" placeholder="Ví dụ: Java, Spring Boot, React...">

								<label>Số thành viên tối đa</label>
								<input type="number" name="maxMembers" value="3" min="1" max="10">

								<label>Học kỳ <span style="color:red">*</span></label>
								<select name="semesterId" required>
									<option value="">-- Chọn học kỳ --</option>
									<c:forEach var="s" items="${semesters}">
										<option value="${s.id}">${s.name}</option>
									</c:forEach>
								</select>

								<label>Trạng thái khởi tạo</label>
								<select name="status">
									<option value="OPEN" selected>OPEN (Công khai cho đăng ký)</option>
									<option value="DRAFT">DRAFT (Lưu nháp / Chờ duyệt)</option>
								</select>
							</div>
						</div>
					</div>
					<div class="modal-footer-custom">
						<button type="button" class="btn-secondary-custom"
							onclick="closeModal('addTopicModal')">Hủy</button>
						<button type="submit" class="btn-add-primary">Tạo đề tài</button>
					</div>
				</form>
			</div>
		</div>

		<!-- Modal 2: Edit Topic Modal -->
		<div class="custom-modal" id="editTopicModal">
			<div class="modal-container">
				<div class="modal-header-custom">
					<h2>✏ Chỉnh sửa đề tài</h2>
					<button type="button" class="modal-close-btn"
						onclick="closeModal('editTopicModal')">&times;</button>
				</div>
				<form method="post" action="${pageContext.request.contextPath}/topics">
					<input type="hidden" name="action" value="update">
					<input type="hidden" name="id" id="editTopicId">
					<div class="modal-body-custom">
						<div class="row">
							<div>
								<label>Tiêu đề đề tài <span style="color:red">*</span></label>
								<input type="text" name="title" id="editTitle" required>

								<label>Mô tả chi tiết <span style="color:red">*</span></label>
								<textarea name="description" id="editDescription" required></textarea>

								<label>Yêu cầu đề tài</label>
								<textarea name="requirements" id="editRequirements"></textarea>
							</div>
							<div>
								<label>Công nghệ sử dụng</label>
								<input type="text" name="technology" id="editTechnology">

								<label>Số thành viên tối đa</label>
								<input type="number" name="maxMembers" id="editMaxMembers" min="1" max="10">

								<label>Trạng thái</label>
								<select name="status" id="editStatus">
									<option value="DRAFT">DRAFT (Lưu nháp / Chờ duyệt)</option>
									<option value="OPEN">OPEN (Đang nhận đăng ký)</option>
									<option value="CLOSED">CLOSED (Hoàn thành / Đóng)</option>
								</select>
							</div>
						</div>
					</div>
					<div class="modal-footer-custom">
						<button type="button" class="btn-secondary-custom"
							onclick="closeModal('editTopicModal')">Hủy</button>
						<button type="submit" class="btn-add-primary">Cập nhật đề tài</button>
					</div>
				</form>
			</div>
		</div>

		<!-- Modal 3: View Topic Detail Modal -->
		<div class="custom-modal" id="viewTopicModal">
			<div class="modal-container">
				<div class="modal-header-custom">
					<h2>👁 Chi tiết đề tài</h2>
					<button type="button" class="modal-close-btn"
						onclick="closeModal('viewTopicModal')">&times;</button>
				</div>
				<div class="modal-body-custom">
					<div style="margin-bottom:16px">
						<span class="topic-code-tag" id="viewCode">DT2024_001</span>
						<h3 id="viewTitle" style="margin:8px 0 4px;font-size:20px;color:#0f172a">Tên đề tài</h3>
						<span id="viewStatusBadge"></span>
					</div>
					<div class="row" style="margin-bottom:16px;background:#f8fafc;padding:16px;border-radius:12px">
						<div>
							<small style="color:#64748b;display:block">Học kỳ</small>
							<strong id="viewSemester" style="color:#0f172a">--</strong>
						</div>
						<div>
							<small style="color:#64748b;display:block">Công nghệ</small>
							<strong id="viewTech" style="color:#0f172a">--</strong>
						</div>
						<div>
							<small style="color:#64748b;display:block">Số thành viên tối đa</small>
							<strong id="viewMembers" style="color:#0f172a">--</strong>
						</div>
					</div>
					<div style="margin-bottom:16px">
						<label style="color:#475569">Mô tả đề tài:</label>
						<div id="viewDesc"
							style="background:#f8fafc;padding:12px;border-radius:10px;font-size:14px;white-space:pre-wrap">
							--</div>
					</div>
					<div>
						<label style="color:#475569">Yêu cầu đồ án:</label>
						<div id="viewReq"
							style="background:#f8fafc;padding:12px;border-radius:10px;font-size:14px;white-space:pre-wrap">
							--</div>
					</div>
				</div>
				<div class="modal-footer-custom">
					<button type="button" class="btn-secondary-custom"
						onclick="closeModal('viewTopicModal')">Đóng</button>
				</div>
			</div>
		</div>

		<!-- Dynamic JS for Modals & Table Filtering -->
		<script>
			function openAddModal() {
				document.getElementById('addTopicModal').classList.add('show');
			}

			function openEditModal(id, title, description, requirements, technology, maxMembers, status) {
				document.getElementById('editTopicId').value = id;
				document.getElementById('editTitle').value = title;
				document.getElementById('editDescription').value = description;
				document.getElementById('editRequirements').value = requirements;
				document.getElementById('editTechnology').value = technology;
				document.getElementById('editMaxMembers').value = maxMembers;
				document.getElementById('editStatus').value = status;
				document.getElementById('editTopicModal').classList.add('show');
			}

			function openViewModal(id, title, description, requirements, technology, maxMembers, semesterName, status) {
				document.getElementById('viewCode').innerText = 'DT2024_00' + id;
				document.getElementById('viewTitle').innerText = title;
				document.getElementById('viewDesc').innerText = description || 'Chưa có mô tả';
				document.getElementById('viewReq').innerText = requirements || 'Chưa có yêu cầu đặc biệt';
				document.getElementById('viewTech').innerText = technology || 'Chưa xác định';
				document.getElementById('viewMembers').innerText = maxMembers + ' sinh viên';
				document.getElementById('viewSemester').innerText = semesterName || 'Chưa phân bổ';

				var badgeHtml = '<span class="status-pill green">Đang thực hiện</span>';
				if (status === 'DRAFT') badgeHtml = '<span class="status-pill orange">Chờ duyệt</span>';
				else if (status === 'CLOSED') badgeHtml = '<span class="status-pill purple">Hoàn thành</span>';
				document.getElementById('viewStatusBadge').innerHTML = badgeHtml;

				document.getElementById('viewTopicModal').classList.add('show');
			}

			function closeModal(modalId) {
				document.getElementById(modalId).classList.remove('show');
			}

			function filterTopics() {
				var query = document.getElementById('searchInput').value.toLowerCase();
				var rows = document.querySelectorAll('.topic-row');
				var visibleCount = 0;

				rows.forEach(function (row) {
					var title = row.getAttribute('data-title') || '';
					var tech = row.getAttribute('data-tech') || '';
					var code = row.getAttribute('data-code') || '';
					if (title.indexOf(query) !== -1 || tech.indexOf(query) !== -1 || code.toLowerCase().indexOf(query) !== -1) {
						row.style.display = '';
						visibleCount++;
					} else {
						row.style.display = 'none';
					}
				});

				document.getElementById('showingCount').innerText = '1 đến ' + (visibleCount > 10 ? 10 : visibleCount);
			}

			function filterByStatus(statusKey) {
				var rows = document.querySelectorAll('.topic-row');
				rows.forEach(function (row) {
					var st = row.getAttribute('data-status');
					if (statusKey === 'ALL') {
						row.style.display = '';
					} else if (statusKey === 'GOOD') {
						row.style.display = ''; // Displays all high rated
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

			function toggleActionMenu(event, menuId) {
				event.stopPropagation();
				var menu = document.getElementById(menuId);
				var isShowing = menu.classList.contains('show');
				document.querySelectorAll('.action-dropdown-menu').forEach(function(m) {
					m.classList.remove('show');
				});
				if (!isShowing) {
					menu.classList.add('show');
				}
			}

			document.addEventListener('click', function() {
				document.querySelectorAll('.action-dropdown-menu').forEach(function(m) {
					m.classList.remove('show');
				});
			});
		</script>

		<%@ include file="../common/footer.jsp" %>