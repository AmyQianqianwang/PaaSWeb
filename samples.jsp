<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.baidu.inf.entity.XMLItems" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.baidu.inf.dao.XMLItemsDao" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8"/>
    <title>Neptune</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0"/>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/neptune.css"/>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/font-awesome.css"/>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/kkpager_blue.css"/>
</head>
<body>

<div class="content-main">
    <div class="sidebar">
        <ul id="side-nav">
            <li><a href="./index.jsp"><i class="icon-home"></i>&nbsp;Home</a>
            </li>
            <li><a href="./neptune.jsp"><i class="icon-list-alt"></i>Neptune</a>
            </li>
            <li class="has_sub">
                <a href="#" class="open" style="padding-right: 10px"><i class="icon-list-alt"></i>Cluster
                    <span class="pull-down"><i class="icon-chevron-down"></i></span>
                </a>
                <ul id="district-list" class="district-list">
                     <%
                         XMLItemsDao itemsDao = new XMLItemsDao();
                         ArrayList<XMLItems> list = itemsDao.getAllItems("neptune.xml");
                         if (list != null && list.size() > 0) {
                             for (int i = 0; i < list.size(); i++) {
                                 XMLItems item = list.get(i);
                     %>
                                 <li><a href="<%=item.getUrl()%>"><%=item.getName()%></a></li>
                     <%
                             }
                         } else {
                     %>
                             <li><a href="errorPage.jsp">no data</a></li>
                     <%
                         }
                     %>
                </ul>
            </li>
        </ul>
    </div>
    <div class="mainbar">
        <%--<div class="page-head" style="padding-bottom:0.4%">
            <h3 class="pull-left" style="margin-top:0.4%"><i class="icon-list-alt"></i> Neptune-Taihang</h3>
            <div class="clearfix"></div>
        </div>--%>
        <div class="page-content">
            <%--<div class="container">--%>
            <div class="panel-body" style="padding:0 0 0 0;">
                <div class="panel panel-info" id="compileInfo">
                    <div class="panel-heading">
                        <a id='get-nav-detail-btn' class='icon-hand-left btn-lg' role='button'></a>
                        <a id='fold-nav-detail-btn' class='icon-hand-right btn-lg' role='button'
                           style='display: none'></a>
                        <h4 class="panel-title" id="infoShow" style="display: inline-block">
                            <span id="districtShow">Taihang</span>&nbsp;&nbsp;&nbsp;&nbsp;
                            <span id="hostShow">HostID</span>
                        </h4>
                    </div>
                    <div class="panel-body" id="compileInfo-result">
                    </div>
                </div>
                <div class="panel panel-info" id="querySelect">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            Search
                        </h4>
                    </div>
                    <div class="panel-body">
                        <form id="formSearch" class="form-horizontal">
                            <div class="form-group" style="margin-top:15px">
                                <label class="control-label col-sm-1" for="querySelectId">ID</label>

                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="querySelectId">
                                </div>
                                <div class="col-sm-4" style="text-align:left;">
                                    <button type="button" style="margin-left:50px" id="btn_query"
                                            class="btn btn-primary">查&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;询
                                    </button>
                                    <button type="button" style="margin-left:50px" id="btn_allQuery"
                                            class="btn btn-primary">高级查询
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="panel panel-info" id="querySelectAll" style="display: none">
                    <div class="panel-heading"><h4 class="panel-title">Advanced Search</h4></div>
                    <div class="panel-body">
                        <form id="formSearchAll" class="form-horizontal">
                            <div class="form-group" style="margin-top:15px">
                                <label class="control-label col-sm-1" for="querySelectAllId">ID</label>

                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="querySelectAllId">
                                </div>
                                <label class="control-label col-sm-1" for="querySelectAllName">Name</label>

                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="querySelectAllName">
                                </div>
                            </div>
                            <div class="form-group" style="margin-top:15px">
                                <label class="control-label col-sm-1" for="querySelectAllSubmitter">Submitter</label>

                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="querySelectAllSubmitter">
                                </div>
                                <label class="control-label col-sm-1" for="querySelectAllQueue">Queue</label>

                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="querySelectAllQueue">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-1" for="querySelectAllPriority">Priority</label>

                                <div class="col-sm-2">
                                    <select id="querySelectAllPriority" style="height: 34px;" class="col-sm-12">
                                        <option value="0"></option>
                                        <option value="1">VERY LOW</option>
                                        <option value="2">LOW</option>
                                        <option value="3">NORMAL</option>
                                        <option value="4">HIGH</option>
                                        <option value="5">VERY HIGH</option>
                                    </select>
                                </div>
                                <label class="control-label col-sm-1" for="querySelectAllStatus">Status</label>

                                <div class="col-sm-2">
                                    <select id="querySelectAllStatus" style="height: 34px;" class="col-sm-12">
                                        <option value="0"></option>
                                        <option value="1">Submit</option>
                                        <option value="2">Pending</option>
                                        <option value="3">Suspend</option>
                                        <option value="4">Running</option>
                                        <option value="5">Failover</option>
                                        <option value="6">Killing</option>
                                        <option value="7">Killed</option>
                                        <option value="8">Succeed</option>
                                        <option value="9">Failed</option>
                                        <option value="10">Running(Killed)</option>
                                        <option value="11">Initing</option>
                                        <option value="12">Waitkill</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create_min" class="col-sm-1 control-label">CreateTime</label>

                                <div class="col-sm-2">
                                    <div class="input-group date" id="createMin">
                                        <input type="text" class="form-control" id="create_min" name="create_min"
                                               placeholder="from">
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                    </div>
                                </div>
                                <div class="col-sm-2">
                                    <div class="input-group date" id="createMax">
                                        <input type="text" class="form-control" id="create_max" name="create_max"
                                               placeholder="to">
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"></label>

                                <div class="col-sm-4" style="text-align:left;">
                                    <button type="button" style="margin-left:50px" id="btn_querySelectAll"
                                            class="btn btn-primary">查询
                                    </button>
                                    <button type="button" style="margin-left:50px" id="btn_queryResetAll"
                                            class="btn btn-primary">重置
                                    </button>
                                    <button type="button" style="margin-left:50px" id="btn_queryFoldAll"
                                            class="btn btn-primary">收起
                                    </button>
                                </div>
                                <label class="col-sm-2 control-label"></label>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="panel panel-info" id="appListData">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseAppList">
                                App List
                            </a>
                        </h4>
                    </div>
                    <div id="collapseAppList" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="table-responsive" id="apps-list">
                                <table class="table table-striped" id="appListTbody">
                                    <thead>
                                    <tr>
                                        <th class="sort asc" style="text-align: left">AppId</th>
                                        <th class="sort">Name</th>
                                        <th class="sort">Queue</th>
                                        <th class="sort">Priority</th>
                                        <th class="sort">Status</th>
                                        <th class="sort">Submit</th>
                                        <th class="sort">Start</th>
                                        <th class="sort">End</th>
                                        <th class="sort">Submitter</th>
                                        <th class="sort">Start</th>
                                    </tr>
                                    </thead>
                                    <tbody class="list" id="appListTbody-result">
                                    </tbody>
                                </table>
                            </div>
                            <div id="kkpager" class="kkpaper" style="width: 80%;margin-left: 10%"></div>

                        </div>
                    </div>
                </div>
                <div class="panel panel-info" id="clusterResourceUseInfo">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseClusterResourceUseInfo">
                                Cluster ResourceUse
                            </a>
                        </h4>
                    </div>
                    <div id="collapseClusterResourceUseInfo" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div id="clusterResourceUse" style="width: 100%;height:500px;
                                 margin:0 50px 0 5px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <span class="totop"><a href="#"><i class="icon-chevron-up"></i></a></span>
</div>

<script type="text/javascript" src="<%=path%>/js/tools/jquery.min.js"></script>
<script src="<%=path%>/js/tools/kkpager.min.js"></script>
<script src="<%=path%>/js/tools/bootstrap.js"></script>
<script src="<%=path%>/js/custom.js"></script>
<script src="<%=path%>/js/tools/moment.min.js"></script>
<script src="<%=path%>/js/tools/bootstrap-datetimepicker.min.js"></script>
<script src="<%=path%>/js/dashboard.js"></script>
<script src="<%=path%>/js/tools/echarts.common.min.js"></script>
<script>
   $('#get-nav-detail-btn').click(function () {
       $(".mainbar").css("margin-left", "148px");
       $('#side-nav').show();
       $('#get-nav-detail-btn').css('display', 'none');
       $('#fold-nav-detail-btn').css('display', '');
   });
   $('#fold-nav-detail-btn').click(function () {
       $(".mainbar").css("margin-left", "0px");
       $('#side-nav').hide();
       $('#get-nav-detail-btn').css('display', '');
       $('#fold-nav-detail-btn').css('display', 'none');
   });


   function getQueryString(name) {
       var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
       var r = window.location.search.substr(1).match(reg);
       var context = '';
       if (r != null) {
           context = r[2];
       }
       reg = null;
       r = null;
       return context === null || context === '' || context === 'undefined' ? '' : context;
   }

   function setGetParams(url, key, value) {
       if (value === '' || value === undefined) {
           return url;
       }
       return url + key + '=' + value + '&';
   }

   /**
    *
    * 获取当前时间
    */
   function p(s) {
       return s < 10 ? '0' + s: s;
   }
   var myDate = new Date();
   //获取当前年
   var year = myDate.getFullYear();
   //获取当前月
   var month = myDate.getMonth()+1;
   //获取当前日
   var date = myDate.getDate();
   var h = myDate.getHours();       //获取当前小时数(0-23)
   var m = myDate.getMinutes();     //获取当前分钟数(0-59)
   var s = myDate.getSeconds();
   var now = year + '-' + p(month) + "-" + p(date) + " " + p(h) + ':' + p(m) + ":" + p(s);

   var district = getQueryString("district");
   function showInfos(pageNum,district) {
       var url = '';
       // var pageNum = pageNum - 1;
       $('#create_min').trigger('input');
       $('#create_max').trigger('input');
       url = setGetParams(url, 'appId', $('#querySelectId').val());
       url = setGetParams(url, 'appId', $('#querySelectAllId').val());
       url = setGetParams(url, 'appName', $('#querySelectAllName').val());
       url = setGetParams(url, 'status', $("#querySelectAllStatus").find("option:selected").text());
       url = setGetParams(url, 'clientIp', $('#querySelectAllSubmitter').val());
       url = setGetParams(url, 'queue', $('#querySelectAllQueue').val());
       url = setGetParams(url, 'create_min', $('#create_min').val());
       url = setGetParams(url, 'create_max', $('#create_max').val());
       url = setGetParams(url, 'priority', $("#querySelectAllPriority").find("option:selected").text());
       var pageParam = 'page=' + pageNum;
       var districtParam = '&district=' + district;
       console.log("url:" + url + pageParam + districtParam);
       $.ajax({
           type: "get",
           dataType: 'json', //接受数据格式
           cache: false,
           url: './servlet/AppDataServlet?action=show',
           data: url + pageParam + districtParam,
           success: function (searchData) {
               // alert("success");
               var appData = searchData.appData;
               var searchStr = "";
               var allData = searchData;
               var host = searchData.host;
               var str = "";
               var compileStr = "";
               var webStartTime = now;
               console.log(webStartTime);
               var version = searchData.version;
               var compiled = webStartTime;
               var compiledat =
                       'example1@example2.baidu.com:/example3/example4/example5';

               for (var i in appData) {
                   searchStr += "<tr>" +
                           "<td><a href = './neptuneTaskInfo.jsp?appId="+ appData[i].appId + "&district="+
                           district +"'>"
                           + appData[i].appId + "</a></td>" +
                           "<td>" + appData[i].appName + "</td>" +
                           "<td><a href = './queueResourceUse.jsp?queue="+ appData[i].queue + "&district="+
                           district +"'>"+ appData[i].queue + "</a></td>" +
                           "<td>" + appData[i].priority + "</td>" +
                           "<td>" + appData[i].status + "</td>" +
                           "<td>" + appData[i].submitTime + "</td>" +
                           "<td>" + appData[i].startTime + "</td>" +
                           "<td>" + appData[i].endTime + "</td>" +
                           "<td>" + appData[i].clientIp + "</td>" +
                           "<td>" + appData[i].startCount + "</td>" +
                           "</tr>";
               }
               compileStr += "<span style='font-weight:bold;'>Web Start At : </span><span id='host' class='text-muted'>"
                       + webStartTime + "</span><br>" +
                       "<span style='font-weight:bold;'>Build Info : </span><span id='host' class='text-muted'>"
                       + compiled + "&nbsp;&nbsp;" + compiledat + "</span><br>";

               window.document.getElementById("compileInfo-result").innerHTML = compileStr;
               $("#appListTbody tbody").html("");
               window.document.getElementById("appListTbody-result").innerHTML = searchStr;
               if (host == null){
                   host = '1.1.1.1'; // 10.102.165.32
               }
               window.document.getElementById("hostShow").innerHTML = host;
               window.document.getElementById("districtShow").innerHTML = district;

               var totalPage = 1;
               if (searchData.pageCount != 0) {
                   totalPage = searchData.pageCount;
               }
               console.log('totalPage=' + totalPage);
               var totalRecords = searchData.count;
               var pageNo = searchData.page;
               if (!pageNo) {
                   pageNo = 1;
               }
               console.log('totalRecords=' + totalRecords);
               console.log('pageNo=' + pageNo);
               kkpager.generPageHtml({
                   pno: pageNo,
                   //总页码
                   total: totalPage,
                   //总数据条数
                   totalRecords: totalRecords,
                   /* 链接前部
                    hrefFormer: 'neptuneDistrict',
                    //链接尾部
                    hrefLatter: '.jsp',
                    getLink: function (n) {
                    return this.hrefFormer + this.hrefLatter + "?page=" + n;
                    console.log("n=" + n);
                    },*/
                   mode : 'click',//默认值是link，可选link或者click
                   click : function(n){
                       this.selectPage(n);
                       showInfos(n, district);
                   }
               },true);
           },
           error: function () {
               //请求出错处理
               alert("No data, please refresh!");
           }
       });
   }
   // 用户未查询之前,初始化页面数据
   showInfos('1',district);

   function resetAllInfos() {
       $('#querySelectAllId').val(null);
       $('#querySelectAllName').val(null);
       $('#querySelectAllSubmitter').val(null);
       $('#querySelectAllQueue').val(null);
       $('#querySelectAllPriority').val(null);
       $('#querySelectAllStatus').val(null);
       $('#create_min').val(null);
       $('#create_max').val(null);
   }


   $('#btn_allQuery').click(function(){
       $('#querySelect').hide();
       $('#querySelectId').val(null);
       $('#querySelectAll').show();
   });
   $('#btn_queryResetAll').bind('click',resetAllInfos);
   $('#btn_queryFoldAll').click(function(){
       $('#querySelect').show();
       $('#querySelectAll').hide();
       resetAllInfos();
   });

   $("#btn_query").click(function (){
       var district = getQueryString('district');
       console.log(district);
       showInfos('0',district);
   });
   $('#btn_querySelectAll').click(function () {
       var district = getQueryString('district');
       console.log(district);
       showInfos('0',district);
   });
   $(function () {
       $('#createMin').datetimepicker({
           format: 'YYYY-MM-DD/HH:mm:ss'
       });
       $('#createMax').datetimepicker({
           format: 'YYYY-MM-DD/HH:mm:ss',
           useCurrent: false
       });
       $('#createMin').on('dp.change', function (e) {
           $('#createMax').data('DateTimePicker').minDate(e.date);
       });
       $('#createMax').on('dp.change', function (e) {
           $('#createMin').data('DateTimePicker').maxDate(e.date);
       });
   });

    $('#get-nav-detail-btn').css('display', 'none');
    $('#fold-nav-detail-btn').css('display', '');

   function formatTimeStamp(timeStamp){
       var date = new Date(timeStamp);
       var Y = date.getFullYear() + '-';
       var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
       var D = date.getDate() + ' ';
       var h = date.getHours() + ':';
       var m = date.getMinutes() + ':';
       var s = date.getSeconds();
       var timeItem = Y+M+D+h+m+s;
       return timeItem;
   }

   $.ajax({
       url:'./servlet/ClusterPhysicalQueueCasioServlet?action=show',
       dataType:'json',
       data:'district=' + district,
       success:function(resourceUseInfo) {
           var resourceUseInfo = resourceUseInfo;
           var times = new Array();
           var timeItem = '';
           var cpuQuota = new Array();
           var cpuUsed = new Array();
           var memoryQuota = new Array();
           var memoryUsed = new Array();
           if(resourceUseInfo.length == 0){
               cpuQuota.push(0);
               cpuUsed.push(0);
               memoryQuota.push(0);
               memoryUsed.push(0);
           } else {
               for(var i = 0;i < resourceUseInfo.length;i++){
                   timeItem = formatTimeStamp(resourceUseInfo[i].timestamp);
                   times.push(timeItem);
                   //times.push(timeStampItem);
                   cpuQuota.push(resourceUseInfo[i].values.cq);
                   cpuUsed.push(resourceUseInfo[i].values.cud);
                   memoryQuota.push(resourceUseInfo[i].values.mq / 1000000);
                   memoryUsed.push(resourceUseInfo[i].values.mu / 1000000); //把kb化为mb
               }
           }
           // drawAppResourceUseChart('appResourceUse', timeStamps,cpuQuota,cpuUsed,memoryQuota,memoryUsed);
           var colors = ['#5793f3', '#d14a61'];
           var clusterResourceUseOption = {
               /*title : {
                text: 'App Casio Resourse',
                subtext: '数据来自casio',
                x: 'center',
                align: 'right'
                },*/
               tooltip: {
                   trigger: 'axis',
                   formatter: function(data) {
                       if(resourceUseInfo.length == 0){
                           data[0].value = 0;
                           data[1].value = 0;
                           data[2].value = 0;
                           data[3].value = 0;
                       }
                       var ret = "time" + "：" + data[0].name +'<br/>' +
                               data[0].seriesName + "："+data[0].value + " Cores" +'<br/>' +
                               data[1].seriesName + "："+data[1].value + " Cores" +'<br/>' +
                               data[2].seriesName + "："+data[2].value + " MB" +'<br/>' +
                               data[3].seriesName + "："+data[3].value + " MB" +'<br/>';
                       return ret;
                   }// 这里是鼠标移上去的显示数据,如果不加这个，则是默认的kv对，没有单位的
               },
               toolbox: {
                   orient: 'horizontal',      // 布局方式，默认为水平布局，可选为：
                   // 'horizontal' ¦ 'vertical'
                   x: 'left',                // 水平安放位置，默认为全图右对齐，可选为：
                   // 'center' ¦ 'left' ¦ 'right'
                   // ¦ {number}（x坐标，单位px）
                   y: 'top',                  // 垂直安放位置，默认为全图顶端，可选为：
                   // 'top' ¦ 'bottom' ¦ 'center'
                   // ¦ {number}（y坐标，单位px）
                   feature: {
                       restore: {show: true},
                       dataView: {show: true, readOnly: false},
                       magicType: {show: true, type: ['line', 'bar']},
                       saveAsImage: {show: true}
                   }
               },
               legend: {
                   data:['cpuQuota','cpuUsed','memoryQuota','memoryUsed']
                   // x: 'right',
                   /*y: '15px',
                    orient: 'vertical',
                    textStyle: {
                    fontWeight: 'bold',
                    fontSize: 13
                    },*/
                   // itemGap: 15
               },
               dataZoom: [
                   {
                       type: 'slider',
                       show: true,
                       realtime: true,
                       start: 0,
                       end: 100
                   },
                   {
                       type: 'inside',
                       realtime: true,
                       dataBackground: {
                           width: 0.5
                       },
                       start: 0,
                       end: 100
                   }
               ],
               xAxis: [
                   {
                       type: 'category',
                       data: times
                   }
               ],
               yAxis: [
                   {
                       type: 'value',
                       name: 'CPU (Cores)',
                       /*min: 0,
                        max: 250,
                        interval: 5,*/
                       axisLine: {
                           lineStyle: {
                               color: colors[0]
                           }
                       }/*,
                       axisLabel: {
                           formatter: '{value} Cores'
                       }*/
                   },
                   {
                       type: 'value',
                       name: 'Memory (MB)',
                       axisLine: {
                           lineStyle: {
                               color: colors[1]
                           }
                       }/*,
                       axisLabel: {
                           formatter: '{value} MB'
                       }*/
                   }
               ],
               series: [
                   {
                       name:'cpuQuota',
                       type:'line',
                       data:cpuQuota
                       /*label:{
                        normal: {
                        show: true,
                        position: 'top',
                        formatter: '{c} Cores'
                        }
                        }*/
                   },
                   {
                       name:'cpuUsed',
                       type:'line',
                       data:cpuUsed
                   },
                   {
                       name:'memoryQuota',
                       type:'line',
                       yAxisIndex: 1,
                       data:memoryQuota
                   },
                   {
                       name:'memoryUsed',
                       type:'line',
                       yAxisIndex: 1,
                       data:memoryUsed
                   }
               ]
           };

           var clusterResourceUseChart = echarts.init(document.getElementById('clusterResourceUse'));
           clusterResourceUseChart.setOption(clusterResourceUseOption);

       },
       error: function () {
           //请求出错处理
           alert("No data, please refresh!");
       }
   });

</script>
</body>
</html>
