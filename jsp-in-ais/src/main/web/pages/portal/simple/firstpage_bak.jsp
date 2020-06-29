<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<meta charset="utf-8" />
	<title>AIS审计管理系统</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport" />
	<meta content="" name="description" />
	<link href="${contextPath}/index/assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/plugins/bootstrap-addtabs/bootstrap.addtabs.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/plugins/jqtip/jquery.qtip.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/global/css/components.min.css" rel="stylesheet" id="style_components" type="text/css" />
	<link href="${contextPath}/index/assets/global/css/plugins.min.css" rel="stylesheet" type="text/css" />
	<link href="${contextPath}/index/assets/layouts/layout2/css/themes/light.css" rel="stylesheet" type="text/css" id="style_color" />
	<style>
		.longTD{
			overflow:hidden;
			white-space:nowrap;
			text-overflow:ellipsis;
		}
	</style>
</head>
<body style="background: white;">
	<div class="container-fluid" style="margin-top: 10px;">
		<div class="row">
			<div class="col-md-6">
				<div class="portlet light bordered" id="todoTask" style="height: 510px;">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>待办事项</div>
						<div class="tools">
							<a href="javascript:;" id="task_reload" title="刷新">
								<i class="glyphicon glyphicon-refresh"></i>
							</a>
							<a href="javascript:;" id="task_more" title="更多">
								<i class="fa fa-angle-double-right"  style="font-size: 1.6em;"></i>
							</a>
						</div>
					</div>
					<div class="portlet-body">
						<div class="table-scrollable">
							<table id="todoTaskTable" style="table-layout:fixed" class="table table-hover table-light">
								<thead>
								<tr>
									<th style="width: 50%;">任务名称</th>
									<th style="width: 20%;">提交人</th>
									<th style="width: 30%;">提交时间</th>
								</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="portlet light bordered" id="planPieChart" style="height: 510px;">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-pie-chart"></i>审计计划执行情况</div>
						<div class="tools">
							<a href="javascript:;" id="plan_reload" title="刷新">
								<i class="glyphicon glyphicon-refresh"></i>
							</a>
						</div>
					</div>
					<div class="portlet-body">
						<div id="planEcharts" style="height: 400px;width:90%;"></div>
					</div>

				</div>
			</div>

		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="portlet light bordered" id="myProjects" style="height: 530px;">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-pie-chart"></i>项目进度统计</div>
						<div class="tools">
							<a href="javascript:;" id="project_reload" title="刷新">
								<i class="glyphicon glyphicon-refresh"></i>
							</a>
						</div>
					</div>
					<div class="portlet-body">
						<div id="projectEcharts" style="height: 400px;width:90%;"></div>
					</div>
			</div>
			</div>
			<div class="col-md-6">
				<div class="portlet light bordered calendar" id="todoCalendar" style="height: 530px;">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-calendar-times-o"></i>日程安排
						</div>
					</div>
					<div class="portlet-body">
						<div id="calendar"> </div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<script type="text/javascript">
		var contextPath = '${contextPath}';
	</script>
	<!--[if lt IE 9]>
	<script src="${contextPath}/index/assets/global/plugins/respond.min.js"></script>
	<script src="${contextPath}/index/assets/global/plugins/excanvas.min.js"></script>
	<![endif]-->
	<!-- BEGIN CORE PLUGINS -->
	<script src="${contextPath}/index/assets/global/plugins/jquery.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/moment.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/fullcalendar/fullcalendar.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/fullcalendar/lang/zh-cn.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/jqtip/jquery.qtip.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/plugins/echarts/echarts.min.js" type="text/javascript"></script>
	<script src="${contextPath}/index/assets/global/scripts/app.min.js" type="text/javascript"></script>

	<script src="${contextPath}/index/firstpage.js" type="text/javascript"></script>
	
	<%-- <jsp:include flush="true" page="/heartbeat.jsp" /> --%>
</body>
</html>