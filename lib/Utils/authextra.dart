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

//BASE_URL
const BASE_URL = 'https://cdashboard.dcservices.in';

//LOGIN_WEB_SERVICE
const LOGIN_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/DashboardUserAuthentication';

//MAIN_MENU_WEB_SERVICE
const MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppMenuService';

//SUB_MENU_WEB_SERVICE
const SUB_MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppSubMenuService';

//SUB_MENU_WEBVIEW_WEB_SERVICE
const SUPER_MENU_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/MobileAppLeafMenuService';

// EDL_CHART_WEB_SERVICE
const EDL_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/StatewiseEDLCount';

// DRILLDOWN_EDL_CHART_WEB_SERVICE
const DRILL_EDL_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/facilityWiseEDLCount';

//RATE_CONTRACT_WEB_SERVICES
const RATE_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/RateContractService';

//RATE_DRUG_TYPE
const RATE_DRUG_TYPE_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/drugType';

//RATE_DRUG_NAME
const RATE_DRUG_NAME_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/drugName';

//DEMAND_YEAR_COMBO_URL
const DEMAND_YEAR =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/yearComboService';

//DEMAND_URL
const DEMAND_URL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/demandAndProcurementStatus';

//COMMAN_ESSANTIAL_DRUGS_FILTER_STATE
const COMMAN_ESSENTAIL_STATE_COMBO =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/stateNameComboService';

    {
        "seatId": "10003",
        "filterIds": ["66"],
        "filterValues": []
      }

//COMMAN_ESSANTIAL_DRUGS_FILTER_FACILITY
const COMMAN_ESSENTAIL_FACILITY_COMBO =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/facilitComboService';

//COMMAN_ESSANTIAL_WEB_SERVICES
const COMMAN_ESSENTAIL =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/CommonEssentialDrugs';

    {
        "seatId": "10003",
        "filterIds": ["66", "67"],
        "filterValues": ["46", "43"]
      }

//COMMAN_ESSANTIAL_WEB_SERVICES
const COMBO_FACILI_STOCKOUTV2 =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/facilitComboService';
       {
        "seatId": "10003",
        "filterIds": ["67"],
        "filterValues": []
      }

//COMMAN_ESSANTIAL_WEB_SERVICES
const COMBO_MONTH_STOCKOUTV2 =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/StockOutMonthComboService';  
       {
        "seatId": "10003",
        "filterIds": ["68"],
        "filterValues": []
      }

//STOCKOUT_DEATILS_V2.0
const MAIN_STOCKOUT_V20 =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/Stock_Out_Detail_V2.0'; 
    {
        "seatId": "10003",
        "filterIds": ["67", "68"],
        "filterValues": ["44", "201803"]
      }

//STATE_COMBO_DRUGS_EXCESS/STORTAGE
const STATE_COMBO_DRUGS_EXCESS =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/stateForDrugAcessShortage'; 
    {
        "seatId": "10003",
        "filterIds": ["69"],
        "filterValues": []
      }

//FACILITY_COMBO_DRUGS_EXCESS/STORTAGE
const FACILITY_COMBO_DRUGS_EXCESS =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/drugNameForDrugExcess';  

    {
        "seatId": "10003",
        "filterIds": ["70"],
        "filterValues": []
      }

//MAIN_DRUGS_EXCESS/STORTAGE
const I_MAIN_DRUGS_EXCESS =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/drugShortExcessService'; 

    {
        "seatId": "10003",
        "filterIds": ["69","70"],
        "filterValues": ["%", "%"]
      }

  //MAIN_DRUGS_EXCESS/STORTAGE
const II_MAIN_DRUGS_EXCESS =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/excessFacilitWiseDrugCountForDrugExcess'; 

  //MAIN_DRUGS_EXCESS/STORTAGE
const III_MAIN_DRUGS_EXCESS =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/shortageFacilitCountDrugExcess'; 

     
{
        "seatId": "10003",
        "filterIds": ["69","70"],
        "filterValues": ["%", "%"]
      }

 //MAIN_SATTE_RC_WEB_SERVICES
const MAIN_STATE_RC =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/StatewiseRCExpiringDetails'; 
   {
        "seatId": "10003",
        "filterIds": [],
        "filterValues": []
      }
    

 //MAIN_DRUG_EXPIRY
const MAIN_DRUG_EXPIRY =
    'https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/DrugExpiryDetailstateWiseDrugExpiry'; 
{
        "seatId": "10003",
        "filterIds": [],
        "filterValues": []
      }
    
    	

class AdminItem {
  final String icon;
  final String color;
  final String name;
  final String url;

  AdminItem({this.name, this.url, this.icon, this.color});
}

class NoInternetException {
  String message;
  NoInternetException(this.message);
}

class NoServiceFoundException {
  String message;
  NoServiceFoundException(this.message);
}

class InvalidFormatException {
  String message;
  InvalidFormatException(this.message);
}

class UnknownException {
  String message;
  UnknownException(this.message);
}
