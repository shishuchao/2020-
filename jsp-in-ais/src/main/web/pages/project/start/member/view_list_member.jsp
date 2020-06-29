<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base target="_self">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>项目小组成员</title>
		<link href="${contextPath}/styles/main/ais.css" rel="stylesheet" type="text/css" />
		<link href="${contextPath}/resources/csswin/subModal.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${contextPath}/scripts/ais_functions.js"></script>
		<script type="text/javascript" src="${contextPath}/resources/csswin/common.js"></script>
		<script type="text/javascript" src="${contextPath}/resources/csswin/subModal.js"></script>
		<script type="text/javascript" src="${contextPath}/scripts/check.js"></script>
		<script type="text/javascript" src="${contextPath}/scripts/calendar.js"></script>
		<script type='text/javascript' src='${contextPath}/scripts/dwr/DWRActionUtil.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/interface/DWRAction.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/engine.js'></script>
		<s:head theme="ajax" />
	</head>
  <body>
  	<s:form id="memberForm" action="saveMember" namespace="/project"> 
  		<s:hidden name="crudId"/>
  		<s:hidden name="proMemberId"/>
  		<s:hidden name="addMemberOption"/>
  		<s:hidden id="zhengTiGroupId" name="group.groupId"/>
		<table id="projectMemberTable" cellpadding="0" cellspacing="1" border="0" bgcolor="#409cce" class="ListTable" align="center">
			<tr>
				<td class="ListTableTr11" nowrap>
					<font color=red>*</font>
					分组名称：
				</td>
				<td class="ListTableTr22">
					<s:select id="groupId" name="proMember.group.groupId"
						list="crudObject.proMemberGroups"
						listKey="groupId" listValue="groupName"
						disabled="false" theme="ufaud_simple"
						templateDir="/strutsTemplate" />
				</td>
			</tr>
			
			<tr>
				<td class="ListTableTr11" nowrap>
					<font color=red>*</font>
					项目角色：
				</td>
				<td class="ListTableTr22">
					<s:select id="role" name="proMember.role"
						list="#@java.util.LinkedHashMap@{'zuzhang':'项目组长','zhushen':'项目主审','fuzuzhang':'项目副组长','zuyuan':'项目参审'}"
						disabled="false" theme="ufaud_simple"
						templateDir="/strutsTemplate" />
				</td>
			</tr>
			<tr>
				<td class="ListTableTr11" nowrap>
					<font color=red>*</font>
					项目成员：
				</td>
				<td class="ListTableTr22">
					<s:buttonText2
						name="proMember.userName" cssStyle="width:90%"
						hiddenName="proMember.userId" hiddenId="userId"
						doubleOnclick="showPopWin('${contextPath}/pages/system/search/mutiselect.jsp?url=${contextPath}/pages/system/morg/userindex4morg.jsp&paraname=proMember.userName&paraid=proMember.userId&p_issel=1',600,420)"
						doubleSrc="${contextPath}/resources/images/s_search.gif"
						doubleCssStyle="cursor:hand;border:0"
						readonly="true" />
				</td>
			</tr>
		</table>
		
		<div align="right" style="width: 96%;">
			<input type="button" value="确定" onclick="toSave()"/>
			&nbsp;&nbsp;
			<input type="button" value="取消" onclick="window.location.href='${contextPath}/project/listMembers.action?crudId=${crudId}'"/>
		</div>
	</s:form>
	
	<script type="text/javascript">
		function toSave(){
			var memberForm = document.getElementById('memberForm');
			var zhengTiGroupId = document.getElementById('zhengTiGroupId').value;
			var groupId = document.getElementById('groupId').value;
			var role = document.getElementById('role').value;
			var userId = document.getElementById('userId').value;
			if(groupId!=zhengTiGroupId && role=='zuzhang'){
				alert('分部类型的小组不允许添加组长!')
				return false;
			}
			if(userId==''){
				alert('请选择要添加的组员!');
				return false;
			}
			memberForm.submit();
		}
	</script>
	
  </body>
</html>