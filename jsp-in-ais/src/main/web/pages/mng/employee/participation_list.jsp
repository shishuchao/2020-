<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<html>
<title>参训情况</title>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="<%=request.getContextPath()%>/resources/csswin/subModal.css" rel="stylesheet" type="text/css"/>
    <link href="<%=request.getContextPath()%>/resources/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="<%=request.getContextPath()%>/easyui/boot.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/createOrgTree.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/easyui/contextmenu.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/pages/tlInteractive/tlInteractiveCommon.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/scripts/check.js"></script>
    <script type="text/javascript" src="${contextPath}/resources/js/jquery-fileUpload.js"></script>
    <script type='text/javascript' src='${contextPath}/scripts/dwr/DWRActionUtil.js'></script>
    <script type='text/javascript' src='${contextPath}/dwr/interface/DWRAction.js'></script>
    <script type='text/javascript' src='${contextPath}/dwr/engine.js'></script>
</head>

<body>
<div id="container" class='easyui-layout' fit='true'>
    <div region="center">
        <table id='sDTable'></table>
    </div>
</div>
<div id='queryCond8'>
    <select id="query_trainTypeCode" name="query_trainTypeCode"></select>
</div>
<jsp:include flush="true" page="/pages/frReportFlow/ajaxloading.jsp"/>
<script type="text/javascript">
    var rowIndexdd;
    var editFlag = undefined;

    function handle(formId) {
        var winUrl = "${contextPath}/workprogram/auditDeptTabFile.action?isView=view&wpd_stagecode=rework&comfirm=y&projectid=" + formId;
        aud$openNewTab("整改行动确认", winUrl, true, false);
    }

    function checkTemplateStatus() {
        var rows = $('#sDTable').datagrid("getRows");

        if (rows && rows.length) {
            var rlen = rows.length;
            for (var i = 0; i < rlen; i++) {
                var row = rows[i];

                if (!row.partime_start || row.partime_start.replace(/\s+/g, "").length == 0) {
                    editFlag = i;
                    $('#sDTable').datagrid('selectRow', editFlag).datagrid('beginEdit', editFlag);
                    showMessage1("第"+(i+1)+"行[参训起始时间]不能为空");
                    return false;
                }
                if (!row.partime_end || row.partime_end.replace(/\s+/g, "").length == 0) {
                    editFlag = i;
                    $('#sDTable').datagrid('selectRow', editFlag).datagrid('beginEdit', editFlag);
                    showMessage1("第"+(i+1)+"行[参训截止时间]不能为空");
                    return false;
                }
                if (!row.par_title || row.par_title.replace(/\s+/g, "").length == 0) {
                    editFlag = i;
                    $('#sDTable').datagrid('selectRow', editFlag).datagrid('beginEdit', editFlag);
                    showMessage1("第"+(i+1)+"行[培训主题]不能为空");
                    return false;
                }
            }
        }

        return true;
    }

    function findFile() {
        var rows = $('#sDTable').datagrid("getRows");
        if (rows.length > 0) {
            for (var t = 0; t < rows.length; t++) {
                var file_id = rows[t].file_id;
                var fileListDiv = "attachFile_" + file_id;
                var uploadBtnDiv = "fileBtn_" + file_id;
                $('#' + fileListDiv).fileUpload({
                    fileGuid: file_id,
                    triggerId: uploadBtnDiv,
                    isDel:${isView!=1},
                    isAdd:${isView!=1},
                    isEdit:${isView!=1},
                    uploadFace: 1,
                    echoType: 2,
                    onFileSubmitSuccess: function (data) {
                        //上传成功后获取文件名称
                        var rtData = $('#' + fileListDiv).fileUpload('getUploadFiles');
                        var fileName = rtData.rows[0].fileName;
                    }
                });
            }
        }
    }

    $.extend($.fn.datagrid.defaults.editors, {
        textarea: {
            init: function (container, options) {
                var input = $('<textarea class="easyui-validatebox" style="display:block;word-break: break-all;word-wrap: break-word;" rows=' + options.rows + '></textarea>').appendTo(container);
                return input.validatebox(options);
            },
            getValue: function (target) {
                return $(target).val();
            },
            setValue: function (target, value) {
                $(target).val(value);
            },
            resize: function (target, width) {
                var input = $(target);
                if ($.boxModel == true) {
                    input.width(width - (input.outerWidth() - input.width()));
                } else {
                    input.width(width);
                }
            }
        },
        text: {
            init: function (container, options) {
                var input = $('<input type="text" class="datagrid-editable-input" style="width: 230px; height: 20px;">').appendTo(container);
                return input.validatebox(options);
            },
            getValue: function (target) {
                return $(target).val();
            },
            setValue: function (target, value) {
                $(target).val(value);
            },
            resize: function (target, width) {
                var input = $(target);
                if ($.boxModel == true) {
                    input.width(width - (input.outerWidth() - input.width()));
                } else {
                    input.width(width);
                }
            }
        }
    });

    $(function () {
        var employeeInfo_id = '${employeeInfo_id}';
        var trainTypeListArr = eval('${trainTypeListArr}');

        frloadOpen();

        aud$genSelectOption('query_trainTypeCode', trainTypeListArr);

        // 重写公共的datagrid删除方法
        var initRemoveFun = QUtil.removeDatagridRows;
        QUtil.removeDatagridRows = function (paramJson, noMsg) {
            var gridObj = $(paramJson.gridObject);
            var rows = gridObj.datagrid('getChecked');
            var pkName = paramJson.pkName ? paramJson.pkName : 'id';
            var delIdArr = new Array();
            var transientRows = new Array();
            if (paramJson.removeFilter) {
                delIdArr = paramJson.removeFilter(rows);
            } else {
                $.each(rows, function (i, row) {
                    if (!row[pkName]) {
                        transientRows.push(row);
                    } else {
                        delIdArr.push(row[pkName]);
                    }
                });
            }
            if (transientRows.length > 0) {
                QUtil.removeViewRows(transientRows, paramJson.gridObject);
            }
            if ((delIdArr.length <= 0 && transientRows.length <= 0) || delIdArr.length > 0) {
                initRemoveFun(paramJson, noMsg);
            }
            $.ajax({url: '${contextPath}/mng/employee/writeBackEmployee.action?id=${employeeInfo_id}', async: false});
        };

        var bodyW = $('body').width();
        var g1 = new createQDatagrid({
            // 表格dom对象，必填
            gridObject: $('#sDTable')[0],
            // 要进行检索的表对象(hibernate bean)名称， 进行拼接hql时使用; 必填
            boName: 'EmployeeParticipation',
            // 对象主键,删除数据时使用-默认为“id”；必填
            pkName: 'id',
            <s:if test="${isSubmit == '1'}">
            whereSql: ' employeeInfo_id=\'' + employeeInfo_id + '\' and isSubmit=\'1\' ',
            </s:if>
            <s:else>
            whereSql: ' employeeInfo_id=\'' + employeeInfo_id + '\'  ',
            </s:else>
            //  order:'asc',
            //  sort:'sn',
            winWidth: 800,
            winHeight: 250,
            gridJson: {
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: false,
                rownumbers: false,
                <s:if test="${isView != '1'}">
                toolbar: [
                    <s:if test="${isSubmit != '1'}">
                    {
                        text: '新增',
                        iconCls: 'icon-add',
                        handler: function () {
                            if (!$('#sDTable').datagrid('validateRow', editFlag)) {
                                showMessage1("必填项不能为空");
                                return;
                            }
                            $("#sDTable").datagrid('endEdit', editFlag);

                            var length = $("#sDTable").datagrid('getRows').length;
                            $("#sDTable").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
                                index: length,
                                row: {
                                    id: '',
                                    employeeInfo_id: employeeInfo_id,
                                    partime_start: '',
                                    partime_end: '',
                                    par_title: '',
                                    par_address: '',
                                    par_type: '',
                                    organizer: '',
                                    file_id: '',
                                    remarks: '',
                                    isSubmit: '0'
                                }
                            });

                            $("#sDTable").datagrid('clearSelections');
                            $("#sDTable").datagrid('beginEdit', length);
                            $("#sDTable").datagrid('selectRow', length);
                            editFlag = length;
                        }
                    }
                    </s:if>
                    <s:else>
                    {
                        text: '新增',
                        iconCls: 'icon-add',
                        handler: function () {
                            if (!$('#sDTable').datagrid('validateRow', editFlag)) {
                                showMessage1("必填项不能为空");
                                return;
                            }
                            $("#sDTable").datagrid('endEdit', editFlag);

                            var length = $("#sDTable").datagrid('getRows').length;
                            $("#sDTable").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
                                index: length,
                                row: {
                                    id: '',
                                    employeeInfo_id: employeeInfo_id,
                                    partime_start: '',
                                    partime_end: '',
                                    par_title: '',
                                    par_address: '',
                                    par_type: '',
                                    organizer: '',
                                    file_id: '',
                                    remarks: '',
                                    isSubmit: '1'
                                }
                            });

                            $("#sDTable").datagrid('clearSelections');
                            $("#sDTable").datagrid('beginEdit', length);
                            $("#sDTable").datagrid('selectRow', length);
                            editFlag = length;
                        }
                    }
                    </s:else>
                    , '-', {
                        text: '保存',
                        iconCls: 'icon-save',
                        handler: function () {
                            if (!$('#sDTable').datagrid('validateRow', editFlag)) {
                                showMessage1("必填项不能为空");
                                return;
                            }

                            $("#sDTable").datagrid('endEdit', editFlag);

                            if(!checkTemplateStatus()){
                                return;
                            }
                            //使用JSON序列化datarow对象，发送到后台。
                            var rows = $("#sDTable").datagrid('getChanges');
                            var rowstr = JSON.stringify(rows);

                            $.ajax({
                                url: '${contextPath}/mng/employee/personnel/saveParticipation.action',
                                async: false,
                                type: 'POST',
                                data: {'rowstr': rowstr},
                                success: function (data) {
                                    if (data == '1') {
                                        showMessage1('保存成功！');
                                        $("#sDTable").datagrid('reload');
                                    }
                                }
                            });
                        }
                    }
                ],
                </s:if>
                columns: [[
                    {field: 'id', title: '选择', checkbox: true, align: 'center', show: 'false'},
                    {
                        field: 'partime_start', title: '参训起始时间', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true,
                        editor: {
                            type: 'datebox',
                            options: {
                                editable: false,
                            }
                        }
                    },
                    {
                        field: 'partime_end', title: '参训截止时间', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true,
                        editor: {
                            type: 'datebox',
                            options: {
                                editable: false,
                            }
                        }
                    },
                    {
                        field: 'par_title', title: '培训主题', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true,
                        editor: {//设置其为可编辑
                            type: 'text',
                            options: {}
                        }
                    },
                    {
                        field: 'par_address', title: '培训地点', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true,
                        editor: {//设置其为可编辑
                            type: 'text',
                            options: {}
                        }
                    },
                    {
                        field: 'par_type', title: '培训类型', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true, type: 'custom', target: $('#queryCond8')[0], show: 'true',
                        editor: {
                            type: 'combobox',
                            options: {
                                data: trainTypeListArr,
                                valueField: "code",
                                textField: "name"
                            }
                        },
                        formatter: function (value, row, index) {
                            var vtext = "";
                            $.each(trainTypeListArr, function (i, jdata) {
                                if (jdata['code'] == value) {
                                    vtext = jdata['name'];
                                    return false;
                                }
                            });
                            // 下拉得到的值是code，这块需要自己手动把name值赋给对应的字段
                            var rtVal = vtext ? vtext : value;
                            return rtVal;
                        }
                    },
                    {
                        field: 'organizer', title: '主办方', width: bodyW * 0.15 + 'px', align: 'center', halign: 'center', sortable: true,
                        editor: {//设置其为可编辑
                            type: 'text',
                            options: {}
                        }
                    },
                    {
                        field: 'file_id', title: '证明材料', width: bodyW * 0.19 + 'px', align: 'center', sortable: true,
                        formatter: function (value, row) {
                            var t = "attachFile_";
                            t = t + row.file_id;
                            var c = "<div  id=\"" + t + "\" ></div>";
                            return c;
                        }
                    },
                    <s:if test="${isView!=1}">
                    {
                        field: 'createfile', title: '附件操作', width: bodyW * 0.13 + 'px', align: 'center', sortable: true, show: 'false', oper: 'eq',

                        formatter: function (value, row) {
                            var c = "";
                            var t = "fileBtn_";
                            t = t + row.file_id;
                            c = "<a href='#'  id=\"" + t + "\" ></a>";

                            return c;
                        }
                    },
                    </s:if>
                    {
                        field: 'remarks', title: '备注说明', width: bodyW * 0.15 + 'px', align: 'left', halign: 'center', sortable: true, show: 'true',
                        editor: {//设置其为可编辑
                            type: 'text'
                        }
                    }
                ]],
                onLoadSuccess: function (data) {
                    $('#sDTable').datagrid('doCellTip', {
                        position: 'bottom',
                        maxWidth: '200px',
                        tipStyler: {
                            'backgroundColor': '#EFF5FF',
                            borderColor: '#95B8E7',
                            boxShadow: '1px 1px 3px #292929'
                        }
                    });
                    findFile();
                    frloadClose();
                },
                onAfterEdit: function (rowIndex, rowData, changes) {//在添加完毕endEdit，保存时触发
                    editFlag = undefined;//重置
                },
                onDblClickCell: function (rowIndex, field, value) {//双击该行修改内容
                    <s:if test="${isView != 'y'}">
                    if (editFlag != undefined) {
                        $("#sDTable").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
                    }
                    if (editFlag == undefined) {
                        $("#sDTable").datagrid('beginEdit', rowIndex);//开启编辑并传入要编辑的行
                        editFlag = rowIndex;
                    }
                    rowIndexdd = rowIndex;
                    </s:if>
                }
            }
        }).batchSetBtn([
            {'index': 1, 'display': ${isView != 1}},
            {'index': 2, 'display': ${isView != 1}},
            {'index': 3, 'display': ${isView != 1}}, //导出到excel
            {'index': 4, 'display': false}, //查询
            {'index': 5, 'display': false},
            {'index': 6, 'display': false},
            {'index': 7, 'display': false},
            {'index': 8, 'display': false}  //刷新
        ]);
    });
</script>
</body>
</html>
