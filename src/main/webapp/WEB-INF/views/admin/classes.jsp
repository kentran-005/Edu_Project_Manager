<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp"%>

<style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Segoe UI,Tahoma,Geneva,Verdana,sans-serif;
    }

    body{
        background:#f4f7fb;
    }

    .page-title{
        font-size:28px;
        font-weight:700;
        color:#2c3e50;
        margin-bottom:25px;
    }

    .card{
        background:#fff;
        border-radius:15px;
        padding:30px;
        box-shadow:0 5px 18px rgba(0,0,0,.08);
        margin-bottom:30px;
    }

    .row{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:30px;
    }

    .form-group{
        margin-bottom:18px;
    }

    label{
        display:block;
        margin-bottom:8px;
        color:#555;
        font-weight:600;
    }

    input,select{
        width:100%;
        padding:12px 14px;
        border:1px solid #dcdfe6;
        border-radius:8px;
        outline:none;
        transition:.3s;
        font-size:15px;
    }

    input:focus,
    select:focus{
        border-color:#4a90e2;
        box-shadow:0 0 5px rgba(74,144,226,.3);
    }

    .btn{
        margin-top:20px;
        background:#4a90e2;
        color:white;
        border:none;
        padding:12px 30px;
        border-radius:8px;
        cursor:pointer;
        font-size:15px;
        font-weight:600;
        transition:.3s;
    }

    .btn:hover{
        background:#357bd8;
    }

    .table-card{
        background:white;
        border-radius:15px;
        padding:20px;
        box-shadow:0 5px 18px rgba(0,0,0,.08);
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#4a90e2;
        color:white;
    }

    th{
        padding:15px;
        text-align:left;
        font-size:15px;
    }

    td{
        padding:14px 15px;
        border-bottom:1px solid #eee;
    }

    tbody tr:hover{
        background:#f5f9ff;
    }

    @media(max-width:768px){

        .row{
            grid-template-columns:1fr;
        }

        table{
            font-size:14px;
        }

    }

</style>

<div class="page-title">
    Quản lý lớp
</div>

<div class="card">

    <form method="post">

        <div class="row">

            <div>

                <div class="form-group">
                    <label>Mã lớp</label>
                    <input name="code" required>
                </div>

                <div class="form-group">
                    <label>Tên lớp</label>
                    <input name="name" required>
                </div>

                <div class="form-group">
                    <label>Ngành</label>
                    <input name="major">
                </div>

            </div>

            <div>

                <div class="form-group">
                    <label>Khóa tuyển sinh</label>
                    <input type="number" name="intakeYear">
                </div>

                <div class="form-group">
                    <label>Cố vấn</label>

                    <select name="advisorId">

                        <option value="">-- Chọn --</option>

                        <c:forEach var="l" items="${lecturers}">
                            <option value="${l.id}">
                                ${l.lecturer_code} - ${l.full_name}
                            </option>
                        </c:forEach>

                    </select>

                </div>

            </div>

        </div>

        <button class="btn">
            Thêm lớp
        </button>

    </form>

</div>

<div class="table-card">

    <table>

        <thead>
            <tr>
                <th>Mã lớp</th>
                <th>Tên lớp</th>
                <th>Ngành</th>
                <th>Khóa</th>
                <th>Cố vấn</th>
            </tr>
        </thead>

        <tbody>

            <c:forEach var="c" items="${classes}">

                <tr>
                    <td>${c.code}</td>
                    <td>${c.name}</td>
                    <td>${c.major}</td>
                    <td>${c.intake_year}</td>
                    <td>${c.advisor_name}</td>
                </tr>

            </c:forEach>

        </tbody>

    </table>

</div>

<%@ include file="../common/footer.jsp"%>