<%@page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML>	
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"> 
		
		<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>  
	<script type="text/javascript" src="${contextPath}/resources/csswin/common.js"></script>

	</head>
	<script type="text/javascript">
  $(function(){
	  $('#zcfgTreeSelect').tree({   
			url:'/ais/industry/tree.action?querySource=tree&state=1',
			text: '行业性质',
		    checkbox:false,
		    animate:false,
		    lines:true,
		    dnd:false,
		    onClick:function(node){
		  		var src = "";
		        if(node.id == '1'){
		        	src = "/ais/industry/edit.action?parentCode=0";
		        }else{
			    	src = "/ais/industry/view.action?id="+node.id;
		        }
                $('#childBasefrm').attr('src',src);
		    }
		});
  });
</script>
	
	<body class="easyui-layout" id="codenameLayout" style="overflow:hidden">
		
			<!-- <table style="display: none;" cellpadding=0 cellspacing=1 border=0 bgcolor="#409cce" class="ListTable" width="100%" align="center">
				<tr class="listtablehead">
					<td colspan="5" align="left" class="edithead">
						<s:property escape="false" value="@ais.framework.util.NavigationUtil@getNavigation('/ais/system/omLogin.action')"/>
					</td>
				</tr>
			</table> -->
		
		<div region="west" title="<%--<img  style='vertical-align: middle; cursor: hand;' onclick=$('img[alt=操作帮助]').trigger('click') src='/ais/images/portal/default/window/icon-question-new.gif' />&nbsp;--%>行业性质维护" style="width:250px;height: 100%" split="true">
	  		<div id="content" style="width: 100%;height: 100%">
	
	  		<ul id='zcfgTreeSelect' class='easyui-tree'></ul>

				<!--<iframe name="menuLeft"  src="/ais/system/omMenu.action" frameborder="0" scrolling="yes" style="width:100%;height:100%;"></iframe>  -->
			</div> 
	    </div>
	    <div region="center" style="overflow:hidden">
	    	<iframe name="childBasefrm" id="childBasefrm" src="../blank.jsp" style="width: 100%;height: 100%;overflow:hidden" frameborder="0">main</iframe>
	    	<!-- <div id="tabs" class="easyui-tabs" fit=true style="overflow: visibility ;"> 
	    		<iframe name="childBasefrm" src="../blank.jsp" width="100%" height="100%" frameborder="0">main</iframe>
	      	</div> -->
	    </div>
	</body>
<%-- <body>
	<table cellpadding=0 cellspacing=1 border=0 bgcolor="#409cce" class="ListTable" width="100%" align="center">
		<tr class="listtablehead"><td colspan="5" align="left" class="edithead">
			<s:property escape="false" value="@ais.framework.util.NavigationUtil@getNavigation('/ais/system/omLogin.action')"/>
		</td></tr>
	</table>
	<div style="height: 85%;padding: 0;margin: 0; border: 0;">
<iframe name="menuLeft" scrolling="Auto" noresize src="/ais/system/omMenu.action" width="20%" height="100%" frameborder="0" >
<iframe name="childBasefrm" src="../blank.jsp" width="80%" height="100%" frameborder="0"><!-- main -->
</div>
</body> --%>
</html>