
var Checkbox = "1";
var SelectedColor = "#C8EDFB";
var topVisible="TRUE";
var ShowLevel="1";
var ShowAll="false";
var SelectSub="true";
var CheckDisabled="false";


var treelist=new Array();
var table=document.createElement("TABLE");
var basedir="/ais/resources/images/";
var rowIndex;
var selectedrow;


var nodeimg=basedir+"newleaf.gif";
var minus=basedir+"newminus.gif";
var puls=basedir+"newplus.gif";

var element = null;


function TreeNode(title,sid,pid,click,value,checked,ffunvalue)
{
   this.title=title;
   this.sid=sid;
   this.pid=pid;
   this.click=click;
   this.level=0;
   this.value=value;
   this.checked=checked;
   this.ffunvalue=ffunvalue;
}


function init()
{ 
    element = document.getElementById('pertree');
    if (element.children.length>0)
    {    
         for (var i=0;i<element.children.length;i++)
	 {
	    
	     if (element.children[i].tagName.toLowerCase()=="p")
	     {
	        var node=element.children[i];
                var thisclick="";
		var value=node.sid;
		var checked=false;
		var ffunvalue="";
		if (node.outerHTML.toLowerCase().indexOf("click=")!=-1)
		       thisclick=node.click;
         	if (node.outerHTML.toLowerCase().indexOf("value=")!=-1&&node.value!=0)
		{
		  value=node.value;
		  ffunvalue=node.value;
		}
		if (node.outerHTML.toLowerCase().indexOf("value=")!=-1&&node.checked!="false")
		  checked=true;
	        treelist[i]=new TreeNode(node.title,node.sid,node.pid,thisclick,value,checked,ffunvalue);
	     }
	 }
    }
    element.innerHTML="";
    ShowTreeView();
    BindSelected();
   

}

function GetSelected()
{
   var result="";
   for (var i=0;i<treelist.length;i++)
    {
       
        var node=treelist[i];
	var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
	if (checknode!=null)
	{
	if (checknode.checked)
	{
	    //result+=checknode.value;
	   // result+=node.value;
	   // if (i<treelist.length-1)
	    //  result+=",";
	      if(result=="")
	      result+=node.value;
	      else
	      result+=","+node.value;
	}
	}

    }
    return result;
}
function GetSelectedValue()
{
   var result="";
   for (var i=0;i<treelist.length;i++)
    {
       
        var node=treelist[i];
	var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
	if (checknode!=null)
	{
	if (checknode.checked)
	{
	    //result+=node.title;
	    //if (i<treelist.length-1)
	    //  result+=",";
	     if(result=="")
	      result+=node.title;
	      else
	      result+=","+node.title;
	}
	}

    }
    return result;
}
function GetSelectedValue4Auth()
{
   var result="";
   for (var i=0;i<treelist.length;i++)
    {
       
        var node=treelist[i];
	var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
	if (checknode!=null)
	{
	if (checknode.checked)
	{
	if(node.ffunvalue!="null" && node.ffunvalue!="" && node.ffunvalue!=null && node.ffunvalue!="underfined"){
	if(result==""){
	result=node.ffunvalue;
	
	}else{
	result+=","+node.ffunvalue;
	}
	    //result+=node.ffunvalue;
	   // if (i<treelist.length-1)
	    //  result+=",";
	    }
	}
	}

    }
    return result;
}
//value[sid]
function GetInfoByStyle()
{
   var result="";
   for (var i=0;i<treelist.length;i++)
    {
       
        var node=treelist[i];
	var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
	if (checknode!=null)
	{
	if (checknode.checked)
	{
	    result+=node.title+"["+node.sid+"]";
	    if (i<treelist.length-1)
	      result+=",";
	}
	}

    }
    return result;
}

function BindSelected()
{
   for (var i=0;i<treelist.length;i++)
    {
        var node=treelist[i];
	
	var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
        if (node.checked)
	{
	   checknode.checked=true;
	}
	
    }
}

function ShowHide()
{
 var d=element.document.getElementById(event.srcElement.value).style;
 if (d!=null)
 {
 var img=event.srcElement;
  if (d.display=="")
  {
   d.display="none";
   img.src=puls;
  }
 else
 {
   d.display="";
   img.src=minus;
 }
 }
}



function ShowTreeView()
{

     if (treelist.length>0)
     {

	for (var i=0;i<treelist.length;i++)
	{
	   if (treelist[i].pid==0)
	   {
	      var parentnode=treelist[i];


	      var haschild=false;
	      
	      if (topVisible=="TRUE")
	      {
	      table.insertRow();
	      table.rows(i).insertCell();
	      
	      
	      var img=document.createElement("img");
			img.runtimeStyle.height=18;
			img.runtimeStyle.width=36;
	      img.border=0;

              if (IshasChildNode(treelist[i]))
	      {
	      img.src=minus;
	      img.value=element.id+"_"+treelist[i].sid;
	      img.attachEvent("onclick",ShowHide);
	      
	      haschild=true;
              }
	      else
	      {
	      img.src=nodeimg;
	     
	      }


	      var div;
	      if (parentnode.click!=null&&parentnode.click!="")
	      {
	          div=document.createElement("A");
	          div.innerText=parentnode.title;
                  div.href="javascript:"+parentnode.click;
		 
	      }
	      else
	      {
	      div=document.createElement("span");
              div.innerText=parentnode.title;

	      }
              table.rows(i).cells(0).vAlign='top';
              table.rows(i).cells(0).appendChild(img);
	      table.rows(i).attachEvent("onclick",changeBg);
              var label=document.createElement("Label");
              label.innerHTML="&nbsp;";
              table.rows(i).cells(0).appendChild(label);
	      if (Checkbox=="1")
	      {
	         var check=document.createElement("input");
                 //check.className="checkstyle"+element.id;
           	 check.type="checkbox";
		 check.value=treelist[i].sid;
		 check.id=element.id+"_ck_0_"+treelist[i].sid;
	if(CheckDisabled!='false'){
	check.disabled="disabled";
	}
	//////?????????????????????
	if(treelist[i].sid=='x1'){
	check.disabled="disabled";
	check.style.display="none";
	}
		 if (haschild)
		 {
		  check.attachEvent("onclick",CheckNodes);
		 }
                 table.rows(i).cells(0).appendChild(check);
	      }
	      table.rows(i).cells(0).appendChild(div);
	      }
	   }
	}


        if (parentnode!=null)
	{
	  rowIndex=1;
	  var level;
         if (topVisible=="TRUE")
	 level=1;
	 else
	 {
	
	  level=0;
	}
	  GetNodeString(parentnode,table,level);

	}
        //alert(table.innerHTML);
	element.appendChild(table);
     }

}

function changeBg()
{
   var ele=event.srcElement;
   
   if (ele.tagName.toLowerCase()=="a")
   {
   ele=ele.parentElement;
   ele.runtimeStyle.background=SelectedColor;
   if (selectedrow!=null)
   {
     selectedrow.runtimeStyle.background='';
   }
   selectedrow=ele;
   }
}


function CheckNodes()
{
   var checknode=element.document.getElementById(event.srcElement.id);
   var check=checknode.checked;
   if(SelectSub=='true')
   checkchild(event.srcElement.value,check);

}
function CheckAllNodes()
{
	for(i=0;i<treelist.length;i++){
		var node=treelist[i];
		var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
		if(!checknode.disabled){
			checknode.checked=true;
		}
		checkchild(node.sid,true);
	}
}
function UnCheckAllNodes()
{
	for(i=0;i<treelist.length;i++){
		var node=treelist[i];
		var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
		if(!checknode.disabled){
			checknode.checked=false;
		}
		checkchild(node.sid,false);
	}
}
function checkchild(id,check)
{
    for (var i=0;i<treelist.length;i++)
    {

        var node=treelist[i];
	if (node.pid==id)
	{

	   var checknode=element.document.getElementById(element.id+"_ck_"+id+"_"+node.sid);
	   checknode.checked=check;
	   checkchild(node.sid,check);
	}
    }
}

function IshasChildNode(node)
{
    for (var j=0;j<treelist.length;j++)
    {
        var tmpnode=treelist[j];
        
	if (tmpnode.pid==node.sid)
	{
	   return true;
	  }
    }
    return false;
}

function getLevelspace(level)
{
   var str="";
   for (var i=0;i<level;i++)
   {
      str+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
   }
   return str;
}

function GetNodeString(node,parenttable,level)
{
     var levelnodecount=0;
     var o_table=null;
     
     for (var i=0;i<treelist.length;i++)
     {
        var thislevel=level;
        var tmpnode=treelist[i];
        if (tmpnode.pid==node.sid)
	{
	    if (levelnodecount==0)
	    {
	       o_table=document.createElement("TABLE");
	       o_table.id=element.id+"_"+node.sid;
	       if(ShowAll=="false"){
	      if (level>parseInt(ShowLevel))
	          o_table.style.display="none";
	          }
	    }

	    o_table.insertRow();
	    o_table.rows(o_table.rows.length-1).insertCell();
            o_table.rows(o_table.rows.length-1).attachEvent("onclick",changeBg);
	    var hasnode=false;
	   //alert(tmpnode.title+" "+tmpnode.pid);
            var _span=document.createElement("Span");
	    _span.innerHTML=getLevelspace(thislevel);

	    var img=document.createElement("img");
	    img.border=0;
	    img.runtimeStyle.height=18;
			img.runtimeStyle.width="36";
            //var div=document.createElement("A");
            if (IshasChildNode(tmpnode))
	    {
	        hasnode=true;
		 if(ShowAll=="false"){
                if (level>=parseInt(ShowLevel))
	        img.src=puls;
		else
		img.src=minus;
		}else{
		img.src=minus;
		}

		img.value=element.id+"_"+tmpnode.sid;
	        img.attachEvent("onclick",ShowHide);
		
	    }
	    else
	    {
	        img.src=nodeimg;
               
	    }

             var div;
	      if (tmpnode.click!=null&&tmpnode.click!="")
	      {
	          div=document.createElement("A");
	          div.innerText=tmpnode.title;
                  div.href="javascript:"+tmpnode.click;
		 
	      }
	      else
	      {
	      div=document.createElement("span");
              div.innerText=tmpnode.title;

	      }

	    o_table.rows(o_table.rows.length-1).cells(0).appendChild(_span);

	    o_table.rows(o_table.rows.length-1).cells(0).appendChild(img);
            var label=document.createElement("Label");
              label.innerHTML="&nbsp;";
            o_table.rows(o_table.rows.length-1).cells(0).appendChild(label);
	     if (Checkbox=="1")
	      {
	         var check=document.createElement("input");

                //check.className="checkstyle"+element.id;
		 check.type="checkbox";
		 check.id=element.id+"_ck_"+tmpnode.pid+"_"+tmpnode.sid;
		 check.value=tmpnode.sid;
		 if(CheckDisabled!='false'){
	check.disabled="disabled";
	}
		 if (hasnode)
		 {
		   check.attachEvent("onclick",CheckNodes);
		  }
                 o_table.rows(o_table.rows.length-1).cells(0).appendChild(check);
	      }
		div.runtimeStyle.width=300;
	    o_table.rows(o_table.rows.length-1).cells(0).appendChild(div);



	    if (hasnode)
	    {

                o_table=GetNodeString(tmpnode,o_table,thislevel+1);
            }
	    levelnodecount++;
	}
     }

      if (o_table!=null&&o_table.rows.length>0)
      {
      parenttable.insertRow();
      parenttable.rows(parenttable.rows.length-1).insertCell();
      parenttable.rows(parenttable.rows.length-1).insertCell();
      parenttable.rows(parenttable.rows.length-1).cells(0).appendChild(o_table);
      }

      return parenttable;
}

function setupStyles() {
   //var oSheet = window.document.createStyleSheet();
   //oSheet.addRule(".checkstyle" + element.id,"BORDER-RIGHT: #ffffff 1px solid; BORDER-TOP: #ffffff 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #ffffff 1px solid;  COLOR: #000000; BORDER-BOTTOM: #ffffff 1px solid; BACKGROUND-COLOR: #ffffff;");
}
function CancelAllNodes()
{
var node=treelist[0];
var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
checknode.checked=false;
checkchild(node.sid,false);

}


function InverseCheck(id)
{
	if(id==undefined){
		var node=treelist[0];
		var checknode=element.document.getElementById(element.id+"_ck_"+node.pid+"_"+node.sid);
		checknode.checked=!checknode.checked;
		InverseCheck(node.sid);
	}
    for (var i=0;i<treelist.length;i++)
    {
		var node=treelist[i];
		if (node.pid==id){
			var checknode=element.document.getElementById(element.id+"_ck_"+id+"_"+node.sid);
			checknode.checked=!checknode.checked;
	  		InverseCheck(node.sid);
		}
    }
}

