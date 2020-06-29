<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">

		<title>审计通知</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link href="${contextPath}/styles/main/ais.css" rel="stylesheet"
			type="text/css">
		<script type='text/javascript' src='${pageContext.request.contextPath}/scripts/turnPage.js'></script>
	</head>
	<script>
function changeSystempromptStatus(id){
	var flag =  confirm('确认删除吗?');
	 if(flag){
	var url = "${contextPath}/bpm/systemprompt/deletePrompt.action?operator_record=deleteTrue&&id="+id;
	window.location = url;
	}else{
	return false;
	}
}


function sendSys(){
var url = "${contextPath}/bpm/systemprompt/editSystemPrompt.action";
window.location = url;
}

function viewSys(id){
var url = "${contextPath}/bpm/systemprompt/viewDetailSystemPrompt.action?id="+id;
window.open(url,"","height=350, width=600, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes,location=no, status=no");
}

function viewALLSys(){
var url = "${contextPath}/bpm/systemprompt/viewUserSend.action";
window.open(viewUserSend,"","height=700px, width=800px, toolbar=no, menubar=no, scrollbars=no,resizable=yes,location=no, status=no");
}
</script>
	<body>
		<center>
			<table>
				<tr class="listtablehead">
					<td colspan="5" align="left" class="edithead">
						<s:property
							escape="false" value="@ais.framework.util.NavigationUtil@getNavigation('/ais/bpm/systemprompt/viewTenDays.action')" />
					</td>
				</tr>
			</table>
			<display:table id="row" name="sysList" pagesize="10" class="its"
				requestURI="${contextPath}/bpm/systemprompt/viewUserSend.action">
				<display:column title="信息" property="description"
					headerClass="center" class="center" sortable="true"  maxLength="50"></display:column>
				<c:set var="createTime" value="${row.createTime}" scope="page"></c:set>
				<display:column title="发送时间" headerClass="center" class="center">
					<s:date name="#attr.createTime" format="yyyy-MM-dd HH:mm:ss" />
				</display:column>
				<display:column title="接收人" property="userName"
					headerClass="center" class="center" sortable="true"></display:column>
				<display:column title="操作" class="center" headerClass="center">
				<a href="javascript:void(0);" onclick="return changeSystempromptStatus('${row.id}');">
						删除</a>
				</display:column>
			</display:table>
			
			<br>
			<div  align="center">
				<s:button value="关 闭" onclick="window.close();"></s:button>
			</div>
		</center>
	</body>
</html>
