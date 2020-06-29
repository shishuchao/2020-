<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<c:set var="smvc" value="<%=request.getContextPath()%>"/>
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="utf-8" />
	<title>AIS审计作业系统</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport" />
	<meta content="" name="description" />
	<!-- BEGIN GLOBAL MANDATORY STYLES -->
	<link href="${smvc}/index/assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="${smvc}/index/assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="${smvc}/index/assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
	<link href="${smvc}/index/assets/global/plugins/bootstrap-addtabs/bootstrap.addtabs.css" rel="stylesheet" type="text/css" />
	<!-- END GLOBAL MANDATORY STYLES -->
	<!-- BEGIN PAGE LEVEL PLUGINS -->
	<!-- END PAGE LEVEL PLUGINS -->
	<!-- BEGIN THEME GLOBAL STYLES -->
	<link href="${smvc}/index/assets/global/css/components.min.css" rel="stylesheet" id="style_components" type="text/css" />
	<link href="${smvc}/index/assets/global/css/plugins.min.css" rel="stylesheet" type="text/css" />
	<!-- END THEME GLOBAL STYLES -->
	<!-- BEGIN THEME LAYOUT STYLES -->
	<link href="${smvc}/index/assets/layouts/layout4/css/layout.min.css" rel="stylesheet" type="text/css" />
	<link href="${smvc}/index/assets/layouts/layout4/css/themes/light.min.css" rel="stylesheet" type="text/css" id="style_color" />
	<!-- END THEME LAYOUT STYLES -->
	<!-- END HEAD -->

<body class="page-header-fixed page-sidebar-closed-hide-logo page-container-bg-solid">
<img src="${smvc}/resources/images/newimg/background.jpg" width="100%" height="100%" style="position: absolute;z-index: -1"/>
<!-- BEGIN HEADER -->
<div class="page-header navbar navbar-fixed-top">
	<div class="page-header-inner ">
		<!-- BEGIN LOGO -->
		<div class="page-logo">
			<a><img src="${smvc}/index/assets/global/img/yonyou.png" alt="logo" class="logo-default" style="margin: 13px 0 0"/> </a>
			</div>
		</div>
		<div class="page-actions" style="font:bold 28px 'Microsoft YaHei', 微软雅黑, 'MicrosoftJhengHei', 华文细黑, 'SimSun', 宋体;color: #096099">
			<%--<label>AIS数字化审计平台</label>position: absolute;left: 20%;top:30%;color: white;--%>
				<label title="AIS审计信息化平台" style="position: absolute;left: 20%;top:30%;font:bold 28px 'Microsoft YaHei', 微软雅黑, 'MicrosoftJhengHei', 华文细黑, 'SimSun', 宋体;">
					AIS审计信息化平台
				</label>
		</div>
		<!-- END PAGE ACTIONS -->
		<!-- BEGIN PAGE TOP -->
		<div class="page-top">
			<!-- BEGIN HEADER SEARCH BOX -->
			<!-- DOC: Apply "search-form-expanded" right after the "search-form" class to have half expanded search box -->
			<!-- END HEADER SEARCH BOX -->
			<!-- BEGIN TOP NAVIGATION MENU -->
			<div class="top-menu">
				<ul class="nav navbar-nav pull-right">
					<!-- BEGIN USER LOGIN DROPDOWN -->
					<!-- DOC: Apply "dropdown-dark" class after below "dropdown-extended" to change the dropdown styte -->
					<li class="dropdown dropdown-user">
						<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
							<span class="username username-hide-on-mobile"> ${user.fdepname}&nbsp;&nbsp;${user.fname} </span>
							<i class="fa fa-angle-down"></i>
						</a>
						<ul class="dropdown-menu dropdown-menu-default">
							<li>
								<a data-toggle="modal" data-target="#acntMngShow">
									<i class="glyphicon glyphicon-user"></i> 账号管理 </a>
							</li>
							<li>
								<a data-toggle="modal" onclick="logout();">
									<i class="glyphicon glyphicon-log-out"></i> 注销 </a>
							</li>
						</ul>
					</li>
					<!-- END USER LOGIN DROPDOWN -->
				</ul>
			</div>
			<!-- END TOP NAVIGATION MENU -->
		</div>
		<!-- END PAGE TOP -->
	</div>
	<!-- END HEADER INNER -->
</div>
<!-- END HEADER -->
<!-- BEGIN HEADER & CONTENT DIVIDER -->
<div class="clearfix"> </div>
<!-- END HEADER & CONTENT DIVIDER -->
<!-- BEGIN CONTAINER -->
<div class="page-container" style="margin-top: 70px;">
	<div class="page-content">
		<div class="row" style="padding-top:10%">
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12 col-lg-offset-2 col-md-offset-4 col-sm-offset-6 col-xs-offset-12">
				<img src="${smvc}/resources/images/newimg/1.png" width="100%" height="100%">
				<a class="dashboard-stat dashboard-stat-v2 blue" href="javascript:;" onclick="openSubsystem('审计管理系统','/portal/simple/simple-firstPageAction!menu.action?parentMenuId=02')">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 审计管理系统 </div>
					</div>
				</a>
			</div>
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12">
				<a class="dashboard-stat dashboard-stat-v2 red" href="javascript:;" onclick="openSubsystem('在线作业系统','/portal/simple/simple-firstPageAction!menu.action?parentMenuId=021&isOnline=Y')">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 在线作业系统 </div>
					</div>
				</a>
			</div>
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12">
				<a class="dashboard-stat dashboard-stat-v2 green" href="javascript:void(0);">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 决策支持系统 </div>
					</div>
				</a>
			</div>
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12">
				<a class="dashboard-stat dashboard-stat-v2 purple" href="javascript:void(0);">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 大数据审计系统 </div>
					</div>
				</a>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12 col-lg-offset-3 col-md-offset-5 col-sm-offset-7 col-xs-offset-12">
				<a class="dashboard-stat dashboard-stat-v2 blue-madison" href="javascript:;" onclick="openSubsystem('审计管理系统','/portal/simple/simple-firstPageAction!menu.action?parentMenuId=02')">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 风险管理系统 </div>
					</div>
				</a>
			</div>
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12">
				<a class="dashboard-stat dashboard-stat-v2 blue-chambray" href="javascript:void(0);">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 工程审计系统 </div>
					</div>
				</a>
			</div>
			<div class="col-lg-2 col-md-4 col-sm-6 col-xs-12">
				<a class="dashboard-stat dashboard-stat-v2 purple-sharp" href="javascript:void(0);">
					<div class="visual">
						<i class="fa fa-comments"></i>
					</div>
					<div class="details">
						<div class="number">
						</div>
						<div class="desc"> 内控评价系统 </div>
					</div>
				</a>
			</div>
		</div>
	</div>
</div>
<!-- END CONTAINER -->
<!-- BEGIN FOOTER -->
<!--
<div class="page-footer">
	<div class="page-footer-inner"> ${copyright}

	</div>
</div>-->
<!-- END FOOTER -->
<script type="text/javascript">
    var contextPath = '${smvc}';
</script>
<!--[if lt IE 9]>
<script src="${smvc}/index/assets/global/plugins/respond.min.js"></script>
<script src="${smvc}/index/assets/global/plugins/excanvas.min.js"></script>
<![endif]-->
<!-- BEGIN CORE PLUGINS -->
<script src="${smvc}/index/assets/global/plugins/jquery.min.js" type="text/javascript"></script>

<script src="${smvc}/index/assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/js.cookie.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/global/plugins/bootstrap-addtabs/bootstrap.addtabs.js" type="text/javascript"></script>
<!-- END CORE PLUGINS -->
<!-- BEGIN THEME GLOBAL SCRIPTS -->
<script src="${smvc}/index/assets/global/scripts/app.min.js" type="text/javascript"></script>
<!-- END THEME GLOBAL SCRIPTS -->
<!-- BEGIN PAGE LEVEL SCRIPTS -->
<!-- END PAGE LEVEL SCRIPTS -->
<!-- BEGIN THEME LAYOUT SCRIPTS -->
<script src="${smvc}/index/assets/layouts/layout4/scripts/layout.js" type="text/javascript"></script>
<script src="${smvc}/index/assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script>
<link href="${smvc}/easyui/1.4/themes/metro/easyui.css" rel="stylesheet" type="text/css"/>
<link href="${smvc}/easyui/1.4/themes/icon.css" rel="stylesheet" type="text/css"/>
<script src="${smvc}/easyui/1.4/jquery.easyui.min.js" type="text/javascript"></script>
<script src="${smvc}/easyui/1.4/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>

<script type="text/javascript">
    $(function(){
      // $('.portlet-body').find('.dashboard-stat').height($('.portlet-body').height());
	});

    function openSubsystem(sysName,link){
        var udswin = window.open(
            contextPath+link, sysName,
            'height=700px, width=800px, toolbar=no, menubar=no, scrollbars=no,resizable=yes,location=no, status=no');
        udswin.moveTo(0, 0);
        udswin.resizeTo(window.screen.availWidth,window.screen.availHeight);
	}
</script>
<!-- END THEME LAYOUT SCRIPTS -->
</body>

</html>

