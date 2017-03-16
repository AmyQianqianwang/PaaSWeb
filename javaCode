//解析xml代码
package com.baidu.inf.dao;

import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.baidu.inf.entity.NeptuneConfigMetaData;

/**
 * Created by wangqianqian02 on 16/12/29.
 */
public class NeptuneConfigManager {

    public static Logger LOG = Logger.getLogger(NeptuneConfigManager.class);
    private Map<String, NeptuneConfigMetaData> configMap = new HashMap<String,
            NeptuneConfigMetaData>();

    public Element readXMLFile(String path) {
        try {
            SAXReader reader = new SAXReader();
             /*Document document = reader.read("/Users/wangqianqian02/Desktop/Projects/baidu/inf-normandy/paasweb/src" +
                    "/main/java/com/baidu/inf/conf/neptuneConfig.xml");*/
            // 如果不设置绝对路径,就会去启动目录tomcat/bin下面找,所以路径就得以tomcat下的bin为准

            URL url = XMLItemsDao.class.getClassLoader().getResource("../conf/");
            // XMLItemsDao.class.getClassLoader().getResource()获取工作目录,""里面拼接上相对于工作目录的路径,加起来就是绝对路径
            Document document = reader.read(url.getPath() + path);

            Element root = document.getRootElement();
            return root;
        } catch (org.dom4j.DocumentException e) {
            e.printStackTrace();
            LOG.error("org.dom4j.DocumentException");
            // LOG.error(e.printStackTrace());
            return null;
        }

    }

    public  NeptuneConfigMetaData getAllConfigInfo(String path, String cluster) {
        try {
            Element rootEle = readXMLFile(path); // 获取根节点
            // ArrayList<NeptuneConfigMetaData> list = new ArrayList<NeptuneConfigMetaData>();

            Iterator clusters = rootEle.elementIterator("cluster");           
            if (configMap.isEmpty()){
                while (clusters.hasNext()) {
                    Set<String> matrixUsersSet = new HashSet<String>();
                    Element clusterEle = (Element) clusters.next();
                    NeptuneConfigMetaData item = new NeptuneConfigMetaData();
                    item.setClusterName(clusterEle.attributeValue("clusterName"));
                    Iterator neptuneMaster = clusterEle.elementIterator("neptuneMaster");
                    Iterator casioMaster = clusterEle.elementIterator("casioMaster");
                    while (neptuneMaster.hasNext()) {
                        Element neptuneMasterEle = (Element) neptuneMaster.next();
                        item.setHistoryRpc(neptuneMasterEle.elementTextTrim("historyRpc"));
                        item.setMMRpc(neptuneMasterEle.elementTextTrim("MMRpc"));
                        item.setHistoryPath(neptuneMasterEle.elementTextTrim("historyPath"));
                        item.setNaPort(Integer.parseInt(neptuneMasterEle.elementTextTrim("NaPort")));
                        item.setDeleteInterval(Long.parseLong(neptuneMasterEle.elementTextTrim("deleteInterval")));
                        item.setUpdateTimeFreq(Long.parseLong(neptuneMasterEle.elementTextTrim("updateTimeFreq")));
                        item.setPageSize(Integer.parseInt(neptuneMasterEle.elementTextTrim("pageSize")));
                    }
                    while (casioMaster.hasNext()) {
                        Element casioMasterEle = (Element) casioMaster.next();
                        item.setCasioHost(casioMasterEle.elementTextTrim("casioHost"));
                        item.setCasioPort(Integer.parseInt(casioMasterEle.elementTextTrim("casioPort")));
                        item.setSearchDBHost(casioMasterEle.elementTextTrim("searchDBHost"));
                        item.setSearchDBPort(Integer.parseInt(casioMasterEle.elementTextTrim("searchDBPort")));
                        item.setCasioInterval(Long.parseLong(casioMasterEle.elementTextTrim("casioInterval")));
                        Iterator matrixUsers = casioMasterEle.elementIterator("matrixUsers");
                        while(matrixUsers.hasNext()){
                            Element matrixUsersEle = (Element) matrixUsers.next();
                            String matrixUser = matrixUsersEle.elementTextTrim("matrixUser");
                            matrixUsersSet.add(matrixUser);
                        }
                        item.setMatrixUsers(matrixUsersSet);
                    }
                    if (!configMap.containsKey(item.getClusterName())) {
                        configMap.put(item.getClusterName(),item);
                    }
                }
            }
            return configMap.get(cluster);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
}
// 访问量Servlet
package com.baidu.inf.dao;

import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import org.apache.log4j.Logger;

import com.baidu.inf.entity.NeptuneStatisticMetaData;
import com.baidu.inf.servlet.AppDataServlet;

/**
 * Created by wangqianqian02 on 17/1/10.
 */
public class NeptuneStatisticDataManager {
    public static Logger LOG = Logger.getLogger(NeptuneStatisticDataManager.class);
    private XMLItemsDao xmlDao = new XMLItemsDao();
    private ArrayList<String> districts = xmlDao.getDistrictItem("neptune.xml");
    AppDataManager appDataManager = new AppDataManager();

    private final AtomicInteger atomicIntegerForStatusCount = new AtomicInteger(0);

    public int getAtomicIntegerForStatusCount() {
        return atomicIntegerForStatusCount.get();
    }

    public Map<String, NeptuneStatisticMetaData> buildNeptuneStatisticFromAppCache() {
        if (atomicIntegerForStatusCount.get() >= 0) {
            atomicIntegerForStatusCount.incrementAndGet();
            for (int i = 0; i < districts.size(); i++) {
                // LOG.info("i am run i=" + i + " of NeptuneStatisticDataManager ");
                if (!AppDataServlet.getNeptuneStatisticMap().containsKey(districts.get(i))) {
                    AppDataServlet.getNeptuneStatisticMap().put(districts.get(i), new NeptuneStatisticMetaData());
                }

                // 访问量构建
                if (AppDataServlet.getAccessCount()[i] == null) {
                    AppDataServlet.getAccessCount()[i] = new AtomicLong(0L);
                } else {
                    AppDataServlet.getNeptuneStatisticMap().get(districts.get(i))
                            .setAccessCount(AppDataServlet.getAccessCount()
                                    [i].get());
                }
                // 不同状态APP数目构建
                if (appDataManager.getStatusCountMap() == null) {
                    LOG.info("no statusCount");
                }
                if (!appDataManager.getStatusCountMap().containsKey(districts.get(i))) {
                    long[] statusCount = {0, 0, 0, 0, 0, 0, 0, 0};
                    appDataManager.getStatusCountMap().put(districts.get(i), statusCount);
                    AppDataServlet.getNeptuneStatisticMap().get(districts.get(i)).setStatusCount(statusCount);
                } else {
                    AppDataServlet.getNeptuneStatisticMap().get(districts.get(i)).setStatusCount(appDataManager
                            .getStatusCountMap().get(districts.get(i)));
                }
            }
            atomicIntegerForStatusCount.decrementAndGet();
        }
        return AppDataServlet.getNeptuneStatisticMap();
    }
}


//taskServlet代码
package com.baidu.inf.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.baidu.inf.dao.TaskCacheDataManager;
import com.baidu.inf.entity.TaskMetaData;
import com.baidu.inf.utils.NUtils;
import com.google.gson.Gson;

/**
 * Created by wangqianqian02 on 16/12/26.
 */
public class TaskDataServlet extends HttpServlet {
    public static Logger LOG = Logger.getLogger(TaskDataServlet.class);
    private static TaskCacheDataManager cacheTask = new TaskCacheDataManager();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        if (request.getParameter("action") != null) {
            String action;
            action = request.getParameter("action");
            Map<String, String> query = NUtils.queryHttpGetToMap(request.getQueryString());
            PrintWriter out = null;
            if (action.equals("show")) {
                if (query.containsKey("appId")) {
                    if (query.containsKey("taskId")) {
                        TaskMetaData.AllData.Task data =
                                cacheTask.obtainTaskData(query.get("appId"), query.get("district")).gettask(query.get
                                        ("taskId"));
                        if (data != null) {
                            data.setHttpName("paasweb");
                        }
                        try {
                            out = response.getWriter();
                            Gson gson = new Gson();
                            String jsonList = gson.toJson(data);
                            out.write(jsonList);

                        } catch (IOException e) {
                            e.printStackTrace();
                        } finally {
                            if (out != null) {
                                out.close();
                            }
                        }
                    } else {
                        LOG.info("no taskid " + query.get("appId") + " and return all task data");
                        if (cacheTask == null) {
                            LOG.info("cacheTask is null");
                        }
                        TaskMetaData.AllData data = cacheTask.obtainTaskData(query.get("appId"),
                                query.get("district")).getAllData();
                        if (data == null) {
                            LOG.info("appId " + query.get("appId")+ " not find");
                            data = new TaskMetaData.AllData();
                            data.setAppid(query.get("appId"));
                            data.setStartCount(-1);
                        }
                        data.setHttpName("paasweb");
                        try {
                            out = response.getWriter();
                            Gson gson = new Gson();
                            String jsonList = gson.toJson(data);
                            out.write(jsonList);
                        } catch (IOException e) {
                            e.printStackTrace();
                        } finally {
                            if (out != null) {
                                out.close();
                            }
                        }
                    }
                }

            }
        }
    }
}

//treeMap排序代码
 public AppCacheDataManager() {
        metaMap = new TreeMap<String, AppMetaData>(new MyComparator());
        appList = new Vector<String>();
        this.comm = HistoryClient.build();
        userInfoMap = new HashMap<String, AmUserInfo>();
 }
 public static class MyComparator implements Comparator {

        public int compare(Object o1, Object o2) {
            String s1 = (String) o1;
            String s2 = (String) o2;
            String str1 = s1.replace('_','-');
            String str2 = s2.replace('_','-');
            return str2.compareTo(str1);
            // app_user_20161111152008_1928 去掉前面"app_user_9"个字符，和后面"_1928"5个或6个字符
        }
    }
//获取数据并分页代码
    public AppMetaData getAppData(Map<String, String> query) {
        AppMetaData appMetaData = new AppMetaData();
        String district = query.get("district");
        int pageSizeInfo = neptuneConfigManager.getAllConfigInfo("neptuneConfig.xml", district).getPageSize();
        int pageSize = pageSizeInfo;
        String page = "0";
        if (query.containsKey("page")) {
            page = query.get("page");
        }
        int pageNo = Integer.parseInt(page);
        appMetaData.setPage(pageNo);
        LinkedList<AppMetaData> appList = new LinkedList<AppMetaData>();
        int count = 0;
        int needcount = pageSize * (pageNo - 1); // 本页所需信息起始下标数=每页个数*（页码-1）
        if (atomicIntegerForMetaMap.get() >= 0) {
            atomicIntegerForMetaMap.incrementAndGet();
            for (AppMetaData value : metaMap.values()) {
                if (query.containsKey("create_min")
                        && NUtils.createToTime(query.get("create_min")) > NUtils
                        .appidToTime(value.getAppId())) {
                    continue;
                }
                if (query.containsKey("create_max")
                        && NUtils.createToTime(query.get("create_max")) < NUtils
                        .appidToTime(value.getAppId())) {
                    continue;
                }
                if (compareData(value, query)) {
                    if (count >= needcount && pageSize > 0) {
                        pageSize--;
                        appList.add(value);
                    }
                    count++;
                    // count从0开始加，加到本页所需下标数。因为每次只能从头遍历map,所以遍历到第needcount个时，就是所需的。
                }
            }
            atomicIntegerForMetaMap.decrementAndGet();

        }
        appMetaData.setCount(count);
        pageSize = pageSizeInfo;
        appMetaData.setPageCount(count / pageSize + ((count % pageSize) == 0 ? 0 : 1)); // 总页数
        AppMetaData[] applist;
        applist = new AppMetaData[appList.size()];
        appList.toArray(applist);
        appMetaData.setAppData(applist);    
        return appMetaData;
    }
    
 //AppMetaData代码
package com.baidu.inf.entity;

import com.google.gson.GsonBuilder;

/**
 * Created by wangqianqian02 on 16/12/21.
 */
public class AppMetaData {
    private AppMetaData[] appData;
    private String status = "";
    private String submitTime = "";
    private String startTime = "";
    private String endTime = "";
    private String appId = "";
    private String queue = "";
    private String priority = "";
    private String appName = "";
    private String clientIp = "";
    private String appUrl = "";
    private String httpName = "";
    private String webStartTime = "";

    private int startCount;
    private int page = 0;
    private int count = 0;
    private String date;
    private int pageCount = 0;
    private String host;

    public AppMetaData[] getAppData() {
        return appData;
    }

    public void setAppData(AppMetaData[] appData) {
        this.appData = appData;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getQueue() {
        return queue;
    }

    public void setQueue(String queue) {
        this.queue = queue;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getAppUrl() {
        return appUrl;
    }

    public void setAppUrl(String appUrl) {
        this.appUrl = appUrl;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public String getHttpName() {
        return httpName;
    }

    public void setHttpName(String httpName) {
        this.httpName = httpName;
    }

    public String getWebStartTime() {
        return webStartTime;
    }

    public void setWebStartTime(String webStartTime) {
        this.webStartTime = webStartTime;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    public void setStartCount(int startCount) {
        this.startCount = startCount;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getStartCount() {
        return startCount;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getPageCount() {
        return pageCount;
    }

    public String getHost() {
        return host;
    }

    @Override
    public String toString() {
        GsonBuilder gb = new GsonBuilder();
        gb.disableHtmlEscaping();
        return gb.create().toJson(this);
    }
}
// AppDataManager代码
 package com.baidu.inf.dao;

import com.baidu.inf.entity.AppMetaData;
import com.baidu.inf.normandy_outside.cam.NormandyOutsideCAM;
import com.baidu.inf.normandy_outside.cmm.NormandyOutsideCMM;
import com.baidu.inf.rpc.HistoryClient;
import com.baidu.inf.utils.NUtils;
import com.google.protobuf.ServiceException;

import normandy_outside.CmmCamCommon;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * Created by wangqianqian02 on 16/12/21.
 */
public class AppDataManager {
    private static final Logger LOG = Logger.getLogger(AppDataManager.class);
    private static Map<String, long[]> statusCountMap = new HashMap<String, long[]>();
    private static Map<String, long[]> statusCountWriteMap = new HashMap<String, long[]>();

    public static Map<String, long[]> getStatusCountMap() {
        return statusCountMap;
    }

    public static Map<String, long[]> getStatusCountWriteMap() {
        return statusCountWriteMap;
    }

    public static void setStatusCountMap(Map<String, long[]> statusCountMap) {
        AppDataManager.statusCountMap = statusCountMap;
    }

    public static AppMetaData buildFromAppFile(HistoryClient.HistoryCommunication comm, String appid, String district)
            throws IOException, ServiceException {
        AppMetaData data = new AppMetaData();
        data.setAppId(appid);
        NormandyOutsideCAM.PAMAppInfo amapp = null;
        int[] startCount = new int[1];
        startCount[0] = -1;
        amapp = comm.getAppFile(appid, startCount, district);
        if (amapp == null) {
            return null;
        }
        data.setPageCount(startCount[0]);
        if (amapp.hasStartTime()) {
            data.setStartTime(timeToString(amapp.getStartTime()));
        }
        if (amapp.hasEndTime()) {
            data.setEndTime(timeToString(amapp.getEndTime()));
        }
        if (amapp.hasSubmitTime()) {
            data.setSubmitTime(timeToString(amapp.getSubmitTime()));
        }
        if (amapp.hasAppName()) {
            data.setAppName(amapp.getAppName());
        }
        String status = amapp.getStatus().toString().substring(2);
        data.setStatus(status);

        if (statusCountWriteMap.containsKey(district)) {
            statusCountWriteMap.get(district)[0]++;
            if (status.equals("Pending")) {
                statusCountWriteMap.get(district)[1]++;
            } else if (status.equals("Initing")) {
                statusCountWriteMap.get(district)[2]++;
            } else if (status.equals("Running")) {
                statusCountWriteMap.get(district)[3]++;
            } else if (status.equals("WaitKill")) {
                statusCountWriteMap.get(district)[4]++;
            } else if (status.equals("Succeed")) {
                statusCountWriteMap.get(district)[5]++;
            } else if (status.equals("Failed")) {
                statusCountWriteMap.get(district)[6]++;
            } else if (status.equals("Killed")) {
                statusCountWriteMap.get(district)[7]++;
            } else if (status.equals("Running(Killed)")) {
                statusCountWriteMap.get(district)[8]++;
            } else if (status.equals("Submit")) {
                statusCountWriteMap.get(district)[9]++;
            } else if (status.equals("Suspend")) {
                statusCountWriteMap.get(district)[10]++;
            } else if (status.equals("Failover")) {
                statusCountWriteMap.get(district)[11]++;
            } else if (status.equals("Killing")) {
                statusCountWriteMap.get(district)[12]++;
            } else {
                LOG.info("App file no match status:" + status + " buildFromAppFile");
            }
        }
        if (status.equals("Running") || status.equals("Pending") || status.equals("Submit")) {
            data.setStatus(status + "(Killed)");
        }

        if (amapp.hasQueue()) {
            data.setQueue(amapp.getQueue());
        }
        /*
         *    if (amapp.hasPriority()) {
         *       data.setPriority(amapp.getPriority().toString().substring(2));
         *    }
         */
        if (amapp.hasSubmitterIp()) {
            data.setClientIp(amapp.getSubmitterIp());
        }
        data.setAppUrl("taskinfo.html?appId=" + data.getAppId());
        return data;
    }

    public static Map<String, AppMetaData> buildFromMaster(HistoryClient.HistoryCommunication comm,
                                                           Map<String, AppCacheDataManager.AmUserInfo> userInfoMap,
                                                           String district) {

        NormandyOutsideCMM.PQueryAllAppResponse pQueryAllAppResponse = null;
        NeptuneConfigManager neptuneConfigManager = new NeptuneConfigManager();
        pQueryAllAppResponse = comm.getQueryAllApp(district);
        if (pQueryAllAppResponse == null || pQueryAllAppResponse.getAppInfoCount() == 0) {
            return null;
        }
        Map<String, AppMetaData> metamap = new TreeMap<String, AppMetaData>(new AppCacheDataManager.MyComparator());
        for (int i = 0; i < pQueryAllAppResponse.getAppInfoCount(); i++) {
            AppCacheDataManager.AmUserInfo userInfoTemp = new AppCacheDataManager.AmUserInfo();
            CmmCamCommon.PAppInfo pAppInfo = pQueryAllAppResponse.getAppInfo(i);
            AppMetaData data = new AppMetaData();
            String mmStatus = "";
            if (pAppInfo.hasAppStatus()) {
                mmStatus = pAppInfo.getAppStatus().toString().substring(5);
            }
            if (pAppInfo.hasAppProfile()) {
                CmmCamCommon.PAppProfile pAppProfile = pAppInfo.getAppProfile();
                String appId = pAppProfile.getAppId();
                data.setAppId(appId);
                data.setQueue(pAppProfile.getQueueName());
                if (pAppProfile.hasStartTime()) {
                    data.setStartTime(timeToString((int) pAppProfile.getStartTime()));
                }
                if (pAppProfile.hasSubmitTime()) {
                    data.setSubmitTime(timeToString((int) pAppProfile.getSubmitTime()));
                } else {
                    data.setSubmitTime(timeToString(NUtils.appidToTime(appId)));
                }
                if (pAppProfile.hasUserAppStatus()) {
                    String status = pAppProfile.getUserAppStatus().substring(2);
                    data.setStatus(status);
                    if (statusCountWriteMap.containsKey(district)) {
                        statusCountWriteMap.get(district)[0]++;
                        if (status.equals("Pending")) {
                            statusCountWriteMap.get(district)[1]++;
                        } else if (status.equals("Initing")) {
                            statusCountWriteMap.get(district)[2]++;
                        } else if (status.equals("Running")) {
                            statusCountWriteMap.get(district)[3]++;
                        } else if (status.equals("WaitKill")) {
                            statusCountWriteMap.get(district)[4]++;
                        } else if (status.equals("Succeed")) {
                            statusCountWriteMap.get(district)[5]++;
                        } else if (status.equals("Failed")) {
                            statusCountWriteMap.get(district)[6]++;
                        } else if (status.equals("Killed")) {
                            statusCountWriteMap.get(district)[7]++;
                        } else if (status.equals("Running(Killed)")) {
                            statusCountWriteMap.get(district)[8]++;
                        } else if (status.equals("Submit")) {
                            statusCountWriteMap.get(district)[9]++;
                        } else if (status.equals("Suspend")) {
                            statusCountWriteMap.get(district)[10]++;
                        } else if (status.equals("Failover")) {
                            statusCountWriteMap.get(district)[11]++;
                        } else if (status.equals("Killing")) {
                            statusCountWriteMap.get(district)[12]++;
                        } else {
                            LOG.info("App file no match status: " + status + " buildFromMaster");
                        }
                    }
                    if ((mmStatus.equals("FAILED") || mmStatus.equals("SUCCESSED") || mmStatus.equals("KILLED"))
                            && (status.equals("Running") || status.equals("Pending")
                                        || status.equals("Submit"))) {
                        data.setStatus(status + "(Killed)");
                    }
                }
                if (data.getStatus().equals("Pending") || data.getStatus().equals("Submit")) {
                    if (pAppProfile.hasHostIp()) {
                        data.setAppUrl("http://" + pAppProfile.getHostIp() + ":"
                                + neptuneConfigManager.getAllConfigInfo("neptuneConfig.xml", district).getNaPort());
                    } else {
                        data.setAppUrl("http://" + pAppProfile.getAppUrl());
                    }
                } else {
                    data.setAppUrl("taskinfo.html?appId=" + data.getAppId());
                } // 如果status为空，那就为空，以此执行else语句，如果上面String status有赋值，那就能判断Pending或者Submit

                if (pAppInfo.hasClientIp()) {
                    data.setClientIp(pAppInfo.getClientIp());
                }
                if (pAppInfo.hasCurrStartCount()) {
                    data.setStartCount(pAppInfo.getCurrStartCount());
                }
                if (pAppProfile.hasAppName()) {
                    data.setAppName(pAppProfile.getAppName());
                }
                if (pAppProfile.hasPriority()) {
                    data.setPriority(pAppProfile.getPriority().toString().substring(2));
                }
                if (pAppProfile.hasEndTime()) {
                    data.setEndTime(timeToString((int) pAppProfile.getEndTime()));
                }
                if (pAppProfile.hasHostIp() && pAppProfile.hasRpcPort()) {
                    userInfoTemp.amRpc = pAppProfile.getHostIp() + ":" + pAppProfile.getRpcPort();
                } // 此处是获取AMrpc的
                userInfoTemp.username = pAppProfile.getUgi().getUser();
                userInfoTemp.nsUrl = "http://" + pAppProfile.getNsHttp();
                userInfoTemp.token = pAppProfile.getUgi().getToken();
                userInfoMap.put(appId, userInfoTemp);
                metamap.put(appId, data);
            }
        }
        return metamap;
    }

    private static String timeToString(int time) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date(time * 1000L));
    }

}
//AppCacheDataManager代码
 
package com.baidu.inf.dao;

import com.baidu.inf.rpc.HistoryClient;
import com.baidu.inf.utils.NUtils;
import com.baidu.inf.entity.AppMetaData;

import org.apache.log4j.Logger;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by wangqianqian02 on 16/12/21.
 */
public class AppCacheDataManager {
    private static final Logger LOG = Logger.getLogger(AppCacheDataManager.class);
    private HistoryClient.HistoryCommunication comm;
    private Map<String, AppMetaData> metaMap;
    private Map<String, AppMetaData> metaLogicCacheMap;
    // metaMap是读缓冲区，metaLogicCacheMap是写缓冲区，在UpdateAppCacheData中更新与交换。TimeServlet会定时调用此方法，更新数据。
    private Vector<String> appList;
    private Map<String, AmUserInfo> userInfoMap;
    private final AtomicInteger atomicIntegerForMetaMap = new AtomicInteger(0);
    NeptuneConfigManager neptuneConfigManager = new NeptuneConfigManager();

    public int getAtomicIntegerForMetaMap() {
        return atomicIntegerForMetaMap.get();
    }

    public HistoryClient.HistoryCommunication getComm() {
        return comm;
    }

    public void setComm(HistoryClient.HistoryCommunication comm) {
        this.comm = comm;
    }

    public Map<String, AppMetaData> getMetamap() {
        return metaMap;
    }

    public void setMetaMap(Map<String, AppMetaData> metamap) {
        this.metaMap = metamap;
    }

    public Map<String, AppMetaData> getMetaLogicCacheMap() {
        return metaLogicCacheMap;
    }

    public void setMetaLogicCacheMap(Map<String, AppMetaData> metaLogicCacheMap) {
        this.metaLogicCacheMap = metaLogicCacheMap;
    }

    public Vector<String> getAppList() {
        return appList;
    }

    public void setAppList(Vector<String> appList) {
        this.appList = appList;
    }

    public Map<String, AmUserInfo> getUserInfoMap() {
        return userInfoMap;
    }

    public void setUserInfoMap(Map<String, AmUserInfo> userInfoMap) {
        this.userInfoMap = userInfoMap;
    }

    public AppCacheDataManager() {
        metaMap = new TreeMap<String, AppMetaData>(new MyComparator());
        appList = new Vector<String>();
        this.comm = HistoryClient.build();
        userInfoMap = new HashMap<String, AmUserInfo>();
    }

    public static class AmUserInfo {
        public String username;
        public String token;
        public String amRpc;
        public String nsUrl;
    }

    public static class MyComparator implements Comparator {

        public int compare(Object o1, Object o2) {
            String s1 = (String) o1;
            String s2 = (String) o2;
            String str1 = s1.replace('_','-');
            String str2 = s2.replace('_','-');
            return str2.compareTo(str1);
            // app_user_20161111152008_1928 去掉前面"app_user_9"个字符，和后面"_1928"5个或6个字符
        }
    }

    public AppMetaData getAppData(Map<String, String> query) {
        AppMetaData appMetaData = new AppMetaData();
        String district = query.get("district");
        int pageSizeInfo = neptuneConfigManager.getAllConfigInfo("neptuneConfig.xml", district).getPageSize();
        int pageSize = pageSizeInfo;
        String page = "0";
        if (query.containsKey("page")) {
            page = query.get("page");
        }
        int pageNo = Integer.parseInt(page);
        appMetaData.setPage(pageNo);
        LinkedList<AppMetaData> appList = new LinkedList<AppMetaData>();
        int count = 0;
        int needcount = pageSize * (pageNo - 1); // 本页所需信息起始下标数=每页个数*（页码-1）
        if (atomicIntegerForMetaMap.get() >= 0) {
            atomicIntegerForMetaMap.incrementAndGet();
            for (AppMetaData value : metaMap.values()) {
                if (query.containsKey("create_min")
                        && NUtils.createToTime(query.get("create_min")) > NUtils
                        .appidToTime(value.getAppId())) {
                    continue;
                }
                if (query.containsKey("create_max")
                        && NUtils.createToTime(query.get("create_max")) < NUtils
                        .appidToTime(value.getAppId())) {
                    continue;
                }
                if (compareData(value, query)) {
                    if (count >= needcount && pageSize > 0) {
                        pageSize--;
                        appList.add(value);
                    }
                    count++;
                    // count从0开始加，加到本页所需下标数。因为每次只能从头遍历map,所以遍历到第needcount个时，就是所需的。
                }
            }
            atomicIntegerForMetaMap.decrementAndGet();

        }
        appMetaData.setCount(count);
        pageSize = pageSizeInfo;
        appMetaData.setPageCount(count / pageSize + ((count % pageSize) == 0 ? 0 : 1)); // 总页数
        AppMetaData[] applist;
        applist = new AppMetaData[appList.size()];
        appList.toArray(applist);
        appMetaData.setAppData(applist);
        return appMetaData;
    }

    private boolean compareData(AppMetaData data1, Map<String, String> query) {
        if (query.containsKey("appId") && !data1.getAppId().contains(query.get("appId"))) {
            return false;
        }
        if (query.containsKey("appName") && !data1.getAppName().contains(query.get("appName"))) {
            return false;
        }
        if (query.containsKey("queue") && !data1.getQueue().contains(query.get("queue"))) {
            return false;
        }
        if (query.containsKey("priority") && !data1.getPriority().equals(query.get("priority"))) {
            return false;
        }
        if (query.containsKey("clientIp") && !data1.getClientIp().equals(query.get("clientIp"))) {
            return false;
        }
        if (query.containsKey("status") && query.get("status").equals("Queue")
                && (data1.getStatus().equals("Submit") || data1.getStatus().equals("Pending"))) {
            return true;
        }
        if (query.containsKey("status") && query.get("status").equals("Completed")
                && (!data1.getStatus().equals("Submit") && !data1.getStatus().equals("Pending")
                            && !data1.getStatus().equals("Running"))) {
            return true;
        }
        if (query.containsKey("status") && !data1.getStatus().equals(query.get("status"))) {
            if (!query.get("status").equals("Killed") || !data1.getStatus().contains("Killed")) {
                return false;
            }
        }
        return true;
    }

}
// UpdataAppCacheData代码
 
 package com.baidu.inf.dao;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.baidu.inf.entity.AppMetaData;
import com.google.protobuf.ServiceException;

/**
 * Created by wangqianqian02 on 16/12/22.
 */
public class UpdateAppCacheData extends TimerTask {
    public static Logger LOG = Logger.getLogger(UpdateAppCacheData.class);
    private Map<String, AppCacheDataManager> cacheApp; // 不用new，直接引用AppDataServlet中的
    private long lastUpdateTime = 0;
    private NeptuneConfigManager neptuneConfigManager = new NeptuneConfigManager();
    private NeptuneStatisticDataManager neptuneStatisticDataManager = new NeptuneStatisticDataManager();
    private XMLItemsDao xmlDao = new XMLItemsDao();
    private ArrayList<String> districts = xmlDao.getDistrictItem("neptune.xml");

    public UpdateAppCacheData(Map<String, AppCacheDataManager> cacheApp) {
        this.cacheApp = cacheApp;
    }

    private static String timeToString(long time) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date(time));
    }

    public void run() {
        List<Long> intervalList = new ArrayList<Long>();
        List<String> metaPathList = new ArrayList<String>();
        long time = System.currentTimeMillis() / 1000;

        for (int i = 0; i < districts.size(); i++) {
            intervalList.add(neptuneConfigManager.getAllConfigInfo("neptuneConfig.xml",
                    districts.get(i)).getDeleteInterval());
            metaPathList.add(neptuneConfigManager.getAllConfigInfo("neptuneConfig.xml",
                    districts.get(i)).getHistoryPath());
            File fileMeta = new File(metaPathList.get(i));
            if (!fileMeta.exists() || !fileMeta.isDirectory()) {
                LOG.info("Conf:" + metaPathList.get(i) + " not found");
                return;
            }
            /*fileMeta = new File("/home/wangqianqian02/meta/user-app-meta/");
            if (!fileMeta.exists() || !fileMeta.isDirectory()) {
                LOG.info("Conf: not found");
                return;
            }*/
            Map<String, AppMetaData> metaLogicCacheMap = null;
            long deleteInterval = intervalList.get(i); // deleteInterval=24 * 60 * 60 在xml中配置
            if (time > lastUpdateTime + deleteInterval) {
                // LOG.debug("deleteTime.substring(0, 10)" + timeToString(time - deleteInterval).substring(0, 10));
                metaLogicCacheMap = new TreeMap<String, AppMetaData>(new AppCacheDataManager.MyComparator());
                if (!cacheApp.containsKey(districts.get(i))) {
                    cacheApp.put(districts.get(i), new AppCacheDataManager());
                    // 如果地区名不存在，则把该地区做为key值加入Map，并新建value，下面构建value即可
                }
            } else {
                if (cacheApp.containsKey(districts.get(i))) {
                    metaLogicCacheMap = cacheApp.get(districts.get(i)).getMetaLogicCacheMap();
                } else {
                    cacheApp.put(districts.get(i), new AppCacheDataManager());
                    metaLogicCacheMap = cacheApp.get(districts.get(i)).getMetaLogicCacheMap();
                }
            }

            if (!AppDataManager.getStatusCountWriteMap().containsKey(districts.get(i))) {
                long[] statusCount = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
                AppDataManager.getStatusCountWriteMap().put(districts.get(i), statusCount);
            } else {
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[0] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[1] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[2] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[3] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[4] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[5] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[6] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[7] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[8] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[9] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[10] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[11] = 0;
                AppDataManager.getStatusCountWriteMap().get(districts.get(i))[12] = 0;
            } // 下次读取app信息，遍历状态之前，把每个地区app各状态数目置为0，避免累加

            cacheApp.get(districts.get(i)).getAppList().removeAllElements();
            Map<String, AppCacheDataManager.AmUserInfo> userInfoMap =
                    new HashMap<String, AppCacheDataManager.AmUserInfo>();
            Map<String, AppMetaData> historyAppDataMap = AppDataManager.buildFromMaster(cacheApp.get(districts.get(
                    i)).getComm(), userInfoMap, districts.get(i));
            cacheApp.get(districts.get(i)).setUserInfoMap(userInfoMap);
            if (historyAppDataMap != null) {
                metaLogicCacheMap.putAll(historyAppDataMap);
            }
            File[] filelist = fileMeta.listFiles();
            // LOG.info("filelist.length=" + filelist.length);
            if (filelist == null) {
                LOG.info("no file in " + metaPathList.get(i));
            } else {
                for (int indexFile = 0; indexFile < filelist.length; indexFile++) {
                    String fileName = filelist[indexFile].getName();
                    if (fileName.endsWith("finished")) {
                        cacheApp.get(districts.get(i)).getAppList()
                                .addElement(fileName.substring(0, fileName.lastIndexOf("-") - 1));
                        // LOG.info(fileName.substring(0, fileName.lastIndexOf("-") - 1));
                    } else {
                        cacheApp.get(districts.get(i)).getAppList().addElement(fileName);
                        // LOG.info(fileName);
                    }
                    if (!fileName.substring(fileName.lastIndexOf("-") + 1).equals("finished")) {
                        continue;
                    }
                    String appName = fileName.substring(0, fileName.lastIndexOf("-") - 1);
                    if (historyAppDataMap != null && historyAppDataMap.containsKey(appName)) {
                        continue;
                    }
                    AppMetaData appMetaData = null;
                    try {
                        appMetaData = AppDataManager.buildFromAppFile(cacheApp.get(districts.get(i)).getComm(),
                                appName, districts.get(i));
                    } catch (ServiceException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    if (appMetaData == null) {
                        continue;
                    }
                    metaLogicCacheMap.put(appName, appMetaData);
                    // 上面cacheApp中已经new了AppCacheDataManager，此处为cache中的metaLogicCacheMap赋值即可
                } // 分别从rpc和file更新meta信息
            }

            if (time > lastUpdateTime + 24 * 60 * 60) {
                cacheApp.get(districts.get(i)).setMetaLogicCacheMap(metaLogicCacheMap);
                // metaLogicCacheMap为临时变量，时间大于一天，就删除之前存储的meta信息，只留下现在的。
            }

            if (cacheApp.get(districts.get(i)).getAtomicIntegerForMetaMap() == 0) {
                cacheApp.get(districts.get(i)).setMetaMap(cacheApp.get(districts.get(i))
                        .getMetaLogicCacheMap());
            } else {
                while (true) {
                    try {
                        Thread.sleep(10);
                        if (cacheApp.get(districts.get(i)).getAtomicIntegerForMetaMap() == 0) {
                            cacheApp.get(districts.get(i)).setMetaMap(cacheApp.get(districts.get(i))
                                    .getMetaLogicCacheMap());
                            break;
                        }
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                }
            }
        } // 如果getAtomicIntegerForMetaMap为0，说明现在没有线程在读，可以进行赋值，否则线程休眠10ms然后重试

        if (neptuneStatisticDataManager.getAtomicIntegerForStatusCount() == 0) {
            AppDataManager.setStatusCountMap(AppDataManager.getStatusCountWriteMap());
        } else {
            while (true) {
                try {
                    Thread.sleep(10);
                    if (neptuneStatisticDataManager.getAtomicIntegerForStatusCount() == 0) {
                        AppDataManager.setStatusCountMap(AppDataManager.getStatusCountWriteMap());
                        break;
                    }
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        } // 如果getAtomicIntegerForStatusCount为0，说明现在没有线程在读，可以进行赋值，否则线程休眠10ms然后重试

        if (time > lastUpdateTime + 24 * 60 * 60) {
            lastUpdateTime = time;
        } // 所有地区都更新完，才能把时间置为现在时间，否则后面的地区都会变为空值
    }
}

 
 
