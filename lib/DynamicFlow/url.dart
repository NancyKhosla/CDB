import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

String mobileusername = 'mobileUser';
String mobilepassword = 'mob123';
String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$mobileusername:$mobilepassword'));
Map<String, String> headers = {
  'content-type': 'text/plain',
  'authorization': basicAuth
};

bool trustSelfSigned = true;
HttpClient httpClient = new HttpClient()
  ..badCertificateCallback =
  ((X509Certificate cert, String host, int port) => trustSelfSigned);
IOClient ioClient = new IOClient(httpClient);

int dashboard_id=3;

//BASE_URL
const BASE_URL = 'https://cdashboard.dcservices.in'; //production
// const BASE_URL = 'https://uatcdash.dcservices.in';  //uat

const MID_URL='/HISUtilities/services/restful/DataService/DATAJSON/';


const LOGIN_URL = BASE_URL+MID_URL+'DashboardUserAuthentication';

// const MAIN_MENU =BASE_URL +MID_URL+'MobileAppMenuService';
// const SUB_MENU =BASE_URL +MID_URL+"MobileAppSubMenuService";
//
// const LEAF_MENU =BASE_URL +MID_URL+"MobileAppLeafMenuService";
//
// const DASHBOARD_CONFIG =BASE_URL +MID_URL +"getDashboardConfiguration";

// const TAB_CONFIG =BASE_URL +MID_URL +"getTabConfiguration";
const PARAMETERS_CONFIG =BASE_URL +MID_URL +"getParamererConfiguration";
// const WIDGETS_CONFIG =BASE_URL +MID_URL +"getWidgetConfiguration";

const M_MENU =BASE_URL +MID_URL+'getmMenus';
const M_PARENT_TABS =BASE_URL +MID_URL+'getmParentTabs';
const M_CHILD_TABS = BASE_URL+MID_URL+'getmChildTabs';
const M_Widgets = BASE_URL+MID_URL+'getmWidgets';



