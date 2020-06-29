<%@page import="java.sql.Date"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%
	String _ServerName = request.getServerName();
	int _ServerPort = request.getServerPort();
	String _CtxPath = request.getContextPath();
	String url_prefix = "http://" + _ServerName + ":" + _ServerPort
			+ _CtxPath;
	String fileId = (String) request.getAttribute("mRecordID");
	String mServerUrl = url_prefix + "/iweb/file" + fileId;
	//传过来的底稿主键，多个，以逗号分隔
	String manuIds = (String) request.getAttribute("crudid");
	String[] manuIdArr = {};
	if (!"".equals(manuIds) && manuIds != null) {
		manuIdArr = manuIds.split(",");
	}
%>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=5">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>工作方案导出</title>
		<link href="${contextPath}/styles/main/ais.css" rel="stylesheet"
			type="text/css">
		<link rel="stylesheet" type="text/css"
			href="${contextPath}/resources/csswin/subModal.css" />
		<script language="javascript">
//作用：显示操作状态
function StatusMsg(mString){
  StatusBar.innerText=mString;
}

//作用：载入iWebOffice
function Load(){
  try{
  <%
		List bmList = (List)request.getAttribute("templateBookMarkList");
  		List bmValList = (List)request.getAttribute("templateBookMarkValList");
  		if(bmList!=null){
  			if(bmList.size()==0){
  				%>
  					alert("该模板没有定义标签，请重新维护改模板！");
  					self.close();
  				<%
  				
  			}
  		}

  		%>
  //以下属性必须设置，实始化iWebOffice
  webform.WebOffice.WebUrl="<%=mServerUrl%>";    //WebUrl:系统服务器路径，与服务器文件交互操作，如保存、打开文档，重要文件
  webform.WebOffice.RecordID="<s:property value="mRecordID"/>";   //RecordID:本文档记录编号
  webform.WebOffice.Template="<s:property value="mRecordID"/>";   //Template:模板编号
  webform.WebOffice.FileName="<s:property value="mFileName"/>";   //FileName:文档名称
  webform.WebOffice.FileType="<s:property value="mFileType"/>";   //FileType:文档类型  .doc  .xls  .wps
  webform.WebOffice.EditType="<s:property value="mEditType"/>";   //EditType:编辑类型  方式一、方式二  <参考技术文档>
  webform.WebOffice.UserName="<s:property value="mUserName"/>";   //UserName:操作用户名
  webform.WebOffice.WebOpen();  	//打开该文档    交互OfficeServer的OPTION="LOADTEMPLATE"
  StatusMsg(webform.WebOffice.Status);
  //测试复制模板
  <%
  //如果选择了多个底稿，则对模板进行复制操作
  	if(manuIdArr.length>1){%>
  		var allDoc=webform.WebOffice.WebObject.Application.Selection;
  		allDoc.WholeStory();
  		allDoc.Copy();
  		var wdStory=6;
  		var wdMove=0;
  		var wdPageBreak=7;
  		var wdFormatOriginalFormatting=16;
  	<%
  		for(int i=1;i<manuIdArr.length;i++){
    %>
			  try{
				  allDoc.EndOf(wdStory,wdMove);
				  allDoc.InsertBreak(wdPageBreak);
				  allDoc.PasteAndFormat(wdFormatOriginalFormatting);
			  }catch(e){
				  alert(e);
			  }
  <%
  		}
 	 }
  %>
  //设置标签值
  SetBookmarks();
  
  //替换换行标签
  replaceParagraphs('[huanhang]');
  
  //光标回到文档开头
  allDoc.HomeKey(wdStory,wdMove);
  }catch(e){}
  //在控件中直接显示文档，需要保存到本地的，自行点击保存到本地按钮
  try{
    webform.WebOffice.WebSaveLocal();
    StatusMsg(webform.WebOffice.Status);
  }catch(e){}
	  
}
//设置bookmark值
function SetBookmarks(){
	<%
		if(bmList!=null&&bmValList!=null&&bmList.size()>0&&bmValList.size()>0){
			//标签长度
			int bmLen = bmList.size();
			//标签对应值长度
			int bmValLen = bmValList.size();
			if(bmValLen%bmLen!=0){ //值个数不是公式的整数倍
	  			%>
		  			alert("底稿中有公式未取到值，可能无法正确导出!");
		  			self.close();
	  			<%
			}
			//共有几张底稿
			int sizeofdoc = bmValLen/bmLen;
			for(int j=0;j<sizeofdoc;j++){
	  			for(int i=0;i<bmList.size();i++){
	  				String bmName = (String)bmList.get(i);
	  				String bmVal="";
	  				Object _obj = bmValList.get(i+bmLen*j);
	  				if(_obj instanceof String){
	  					bmVal = (String)_obj;
	  				}else if(_obj instanceof Date){
	  					bmVal = ((Date)_obj).toString();
	  				}
		  			%>
		  			setBookMarkVals("<%=bmName%>","<%=bmVal.replaceAll("\n","[huanhang]").replaceAll("\r","[huanhang]").replaceAll("\"","“")%>");
		  			<%	
	  			}
	  		}
		}
	%>
}
/**
 *作用：根据标签名设定标签值
 */
function setBookMarkVals(bookmark,bookmarkval){
	try{
		var tableDocRange =webform.WebOffice.WebObject.Application.Selection.Range;
		tableDocRange.Find.Wrap = 1;
		while(tableDocRange.Find.Execute(bookmark)){
			var start = tableDocRange.Start;
			var end = tableDocRange.End;
			var formulaRan = webform.WebOffice.WebObject.Range(start,end);
			if(typeof bookmarkval=='string' && bookmarkval.substr(0,5)=='table'){
				// 表格处理
				// 取得表格行列值
				var rc = bookmarkval.substring(bookmarkval.indexOf("{") + 1, bookmarkval.indexOf("}"));
                var rcs = rc.split(",");
                var rows = rcs[0];// 表格行数
                var cols = rcs[1];// 表格列数
                if(rows > 0){
                	var tbvalue = bookmarkval.substr(bookmarkval.indexOf("}") + 1, bookmarkval.length);// 表格内容
			        formulaRan.Text = tbvalue;
			        var onetable = formulaRan.ConvertToTable('|', rows, cols);
			        onetable.Borders.InsideLineStyle = 1;
			        onetable.Borders.OutsideLineStyle = 1;
                }else{
                	formulaRan.Text = "";// 行数为0，输出空
                }
		   }
		<%-- else if (bookmark == "[审计记录]"){
			   // 富文本处理
			   if(bookmarkval == ""){
				   formulaRan.Text = bookmarkval;
			   }else{
				   formulaRan.InsertFile("<%=url_prefix%>/tmpfiles/" + bookmarkval + ".html");
				   //删除临时文件
				   frmdeltmp.location.href = "${contextPath}/commons/oaprint/deleteDescibeFile.action?dwrModuleid=" + bookmarkval + ".html";
				
					
			   }
		   } --%>
		   else if (bookmark == "[审计证据]"){
			   // 富文本处理
			   if(bookmarkval == ""){
				   formulaRan.Text = bookmarkval;
			   }else{
				   formulaRan.InsertFile("<%=url_prefix%>/tmpfiles/" + bookmarkval + ".html");
				   //删除临时文件
				   frmdeltmp.location.href = "${contextPath}/commons/oaprint/deleteDescibeFile.action?dwrModuleid=" + bookmarkval + ".html";
			   }
		   }else{
			   // 非表格处理
			   formulaRan.Text = bookmarkval;
		   }
			//查找一次就停了
			break;
		}
	}catch(e){
		alert(e.message);
	}
}

/**
 *作用：替换换行标签
 * bookmark 换行标签
 */
function replaceParagraphs(bookmark){
	try{
		var tableDocRange =webform.WebOffice.WebObject.Application.Selection.Range;
		tableDocRange.Find.Wrap = 1;
		while(tableDocRange.Find.Execute(bookmark)){
			var start = tableDocRange.Start;
			var end = tableDocRange.End;
			var formulaRan = webform.WebOffice.WebObject.Range(start,end);
			formulaRan.InsertParagraph();
		}
	}catch(e){
		alert(e);
	}
}

//作用：退出iWebOffice
function UnLoad(){
  try{
  if (!webform.WebOffice.WebClose()){
     StatusMsg(webform.WebOffice.Status);
  }else{
     StatusMsg("关闭文档...");
  }
  }catch(e){}
}


//作用：打开文档
function LoadDocument(){
  StatusMsg("正在打开文档...");
  if (!webform.WebOffice.WebLoadTemplate()){  //交互OfficeServer的OPTION="LOADTEMPLATE"
     StatusMsg(webform.WebOffice.Status);
  }else{
     StatusMsg(webform.WebOffice.Status);
  }
}
//作用：打印文档
function WebOpenPrint(){
  try{
    webform.WebOffice.WebOpenPrint();
    StatusMsg(webform.WebOffice.Status);
  }
  catch(e){
    alert(e.description);
  }
}

//作用：存为本地文件
function WebSaveLocal(){
  try{
    webform.WebOffice.WebSaveLocal();
    StatusMsg(webform.WebOffice.Status);
  }catch(e){}
}

//作用：打开本地文件
function WebOpenLocal(){
  try{
    webform.WebOffice.WebOpenLocal();
    StatusMsg(webform.WebOffice.Status);
  }catch(e){}
}
</script>
	</head>
	<body bgcolor="#ffffff" onload="Load()" onunload="UnLoad()" rightmargin="10"
		style="display: none; overflow: hidden;">
		<!--引导和退出iWebOffice-->
		<form name="webform" method="post"
			action="${contextPath}/commons/oaprint/saveTemplate.action"
			onsubmit="return SaveDocument();">
			<!--保存iWebOffice后提交表单信息-->
			<table cellpadding=0 cellspacing=0 border=0 bordercolor="red"
				style="width:100%;height:100%">
				<tr>
					<td align=right class="listtabletr11" eight="30">
						<input type="hidden" name="RecordID"
							value="<s:property value="mRecordID"/>">
						<iframe id="frmdeltmp" name="frmdeltmp" style="display: none;"
							src="about:blank"></iframe>
						<input type=button value="保存本地文件" onclick="WebSaveLocal()">
						<input type=button value="打印文件" onclick="WebOpenPrint()">
						<input type=button value="关闭" onclick="self.close()">
					</td>
				</tr>
				<tr>
					<td height="20">
						<div id=StatusBar>
							状态栏
						</div>
					</td>
				</tr>
				<tr>
					<td height="100%">
						<!--调用iWebOffice，注意版本号，可用于升级-->
						<%@ include file="/pages/commons/file/iwebOfficeControl.jsp"%>


					</td>
				</tr>
			</table>
			<s:hidden name="mRecordID" />
			<s:hidden name="mFileName" />
			<s:hidden name="mDescript" />
			<s:hidden name="mModulename" />
		</form>

	</body>
</html>
