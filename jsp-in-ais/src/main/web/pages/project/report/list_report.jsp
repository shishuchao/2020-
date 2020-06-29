<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>终结阶段列表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link href="${contextPath}/styles/main/ais.css" rel="stylesheet" type="text/css" />
		<link href="${contextPath}/resources/csswin/subModal.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${contextPath}/resources/csswin/common.js"></script>
		<script type="text/javascript" src="${contextPath}/resources/csswin/subModal.js"></script>
		<script type="text/javascript" src="${contextPath}/scripts/ais_functions.js"></script>
		<script type='text/javascript' src='${contextPath}/scripts/dwr/DWRActionUtil.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/interface/DWRAction.js'></script>
		<script type='text/javascript' src='${contextPath}/dwr/engine.js'></script>
		<script type='text/javascript' src='${pageContext.request.contextPath}/scripts/turnPage.js'></script>
	</head>
	<body>
		<table cellpadding=0 cellspacing=1 border=0 bgcolor="#409cce"
			class="ListTable" width="100%" align="center">
			<tr class="listtablehead">
				<td colspan="5" align="left" class="edithead">
					<s:if test="'${projectType}'==@ais.project.ProjectContant@NBZWPG">
						<s:property escape="false" value="@ais.framework.util.NavigationUtil@getNavigation('/ais/project/report/listAll.action?projectType=${projectType}')"/>
					</s:if>
					<s:else>
						<s:property escape="false" value="@ais.framework.util.NavigationUtil@getNavigation('/ais/project/report/listAll.action')"/>
					</s:else>
					
				</td>
			</tr>
		</table>
		<s:form action="listAll" namespace="/project/report" method="post">
			<div align="center">
				<display:table id="row" name="projectList" pagesize="10" class="its"
					requestURI="${contextPath}/project/report/listAll.action">
					
					<display:column title="项目名称" headerClass="center"
						property="includeObject.project_name" style="WHITE-SPACE: pre-wrap"
						sortable="true" />
						
					<display:column title="项目编号" headerClass="center"
						style="WHITE-SPACE: nowrap" property="includeObject.project_code"
						sortable="true" />
					<s:if test="'${projectType}'==@ais.project.ProjectContant@NBZWPG">	
						<display:column title="内控专岗负责人" headerClass="center"
							style="WHITE-SPACE: nowrap" class="center" property="includeObject.pro_teamleader_name"
							sortable="true" />
					</s:if>
					<s:else>			
						<display:column title="计划类别" headerClass="center"
							style="WHITE-SPACE: nowrap" class="center" property="includeObject.plan_type_name"
							sortable="true" />
							
						<display:column title="项目类别" headerClass="center" class="center"
							property="includeObject.pro_type_name" sortable="true"
							style="WHITE-SPACE: pre-wrap" />
						<%-- 
						<display:column title="计划等级" headerClass="center" class="center"
							property="includeObject.plan_grade_name" sortable="true"
							style="WHITE-SPACE: nowrap" />
						  --%>
						<display:column title="所属单位" headerClass="center"
							style="WHITE-SPACE: pre-wrap" class="center"
							property="includeObject.audit_dept_name" maxLength="10" sortable="true" />
					</s:else>
					
					<display:column title="开始日期" headerClass="center"
						style="WHITE-SPACE: nowrap" class="center"
						property="includeObject.pro_starttime" maxLength="10" sortable="true" />
						
					<display:column title="结束日期" headerClass="center"
						style="WHITE-SPACE: nowrap" class="center"
						property="includeObject.pro_endtime" maxLength="10" sortable="true" />
					
					<display:column title="操作" headerClass="center"
						style="WHITE-SPACE: nowrap" class="center" media="html">
						<c:set var="canEdit" value="false" />
						<s:if test="${row.formState!='0'}">
							<c:set var="canEdit" value="false" />
						</s:if>
						<s:else>
							<c:forEach items="${row.includeObject.proMembers}" var="proMember">
								<c:if test="${user.floginname==proMember.userId&&proMember.group.groupType=='zhengti'&&(proMember.role=='zuzhang'||proMember.role=='fuzuzhang'||proMember.role=='zhushen')}">
									<c:set var="canEdit" value="true" />
								</c:if>
							</c:forEach>
						</s:else>
						<c:choose>
						   <c:when test="${canEdit}">
						   		<s:if test="'${projectType}'==@ais.project.ProjectContant@NBZWPG">
						   			<a href="${contextPath}/project/report/edit.action?crudId=${row.formId}&projectType=${projectType}">处理</a>
						   		</s:if>
						   		<s:else>
						   			<a href="${contextPath}/project/report/edit.action?crudId=${row.formId}">处理</a>
						   		</s:else>
						   </c:when>
						   <c:otherwise>
						   		<s:if test="'${projectType}'==@ais.project.ProjectContant@NBZWPG">
						   			<a href="${contextPath}/project/report/view.action?crudId=${row.formId}&projectType=${projectType}" target="_blank">查看</a>
						   		</s:if>
						   		<s:else>
						   			<a href="${contextPath}/project/report/view.action?crudId=${row.formId}" target="_blank">查看</a>
						   			<a href="${contextPath}/project/feedback/idea/noProcessIdea.action?form_id=${row.formId}&processType=report&project_id=${row.includeObject.formId}&project_code=${row.includeObject.project_code}" target="_blank">处理意见</a>
						   		</s:else>
						   </c:otherwise>
						</c:choose>
					</display:column>
					
					<display:setProperty name="paging.banner.placement" value="bottom" />
					
				</display:table>
				
			</div>
		</s:form>
	</body>
</html>
