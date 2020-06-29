<!DOCTYPE HTML>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
	<head><meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>审计方案库维护</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>   
		<meta http-equiv="expires" content="0">
		</head>
		<script type="text/javascript">
			function doAutoHeight1() {
				if(document.body.clientHeight>165)
			    	document.all.preArchivesInfoFrame.style.height = document.body.clientHeight-110;
		    }
		
			function doAutoHeight2() {
				if(document.body.clientHeight>165)
			    	document.all.afterArchivesInfoFrame.style.height = document.body.clientHeight-110;
		    }
		    $(function(){
		    	$('#test').tabs({ 
			        border:false, 
			        onSelect:function(title,index){ 
						if(index == 1){
							var src = $('#afterArchivesInfoFrame').attr('src');
							if(src == ''){
								$('#afterArchivesInfoFrame').attr('src','<%=request.getContextPath()%>/operate/template/listRet.action?publishAuth=${publishAuth}&interCtrl=${interCtrl}');
							}
						}
			        } 
			    });
		    });
		</script>
		<body style="margin: 0;padding: 0;overflow:hidden;" class="easyui-layout" fit='true' border='0'>
			<div region="center" border='0'>
				<div class="easyui-tabs" fit="true" id="test" border='0'>
					<div id="preArchivesInfo" title="预制方案" style="overflow:hidden;">
						<iframe id="preArchivesInfoFrame"
							src="${contextPath}/operate/template/list.action?interCtrl=${interCtrl}" style="overflow:hidden;"
							frameborder="0" width="100%" height="100%"  ></iframe>
					</div>
					<div id="afterArchivesInfo" title="回传方案" style="overflow:hidden;">
						<iframe id="afterArchivesInfoFrame" src="" style="overflow:hidden;"
							frameborder="0" width="100%" height="100%" ></iframe>
					</div>
				</div>
			<div>
	</body>
</html>
