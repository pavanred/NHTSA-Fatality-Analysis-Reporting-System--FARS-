
public class DataBean  {
  
  private int _Year_;
  
  private int _Age_;

  
  private int _Alcohol_;

  
  private int _BodyType_;

  
  private int _CaseNumber_;

  
  private int _City_;

  
  private int _County_;

  
  private int _CrashDate_;

  
  private int _CrashFactor_;

  
  private int _CrashHour_;

  
  private int _DriverFactors_;

  
  private int _Fatalities_;

  
  private int _HolidayRelated_;

  
  private int _Id_;

  
  private int _InjurySeverity_;

  
  private float _Latitude_;

  
  private int _LicenseState_;

  
  private int _LightCondition_;

  
  private float _Longitude_;

  
  private int _MannerOfCollision_;

  
  private int _NationalHighway_;

  
  private int _PersonNumber_;

  
  private int _PersonType_;

  
  private int _PreviousAccidents_;

  
  private int _RoadwaySurface_;

  
  private int _Sex_;

  
  private int _SpeedLimit_;

  
  private int _State_;

  
  private int _TravelSpeed_;

  
  private int _VehicleFactors_;

  
  private int _VehicleMake_;

  
  private int _VehicleNumber_;

  
  private int _Weather_;
  
  private String _countyName_;
  
  private String _stateName_;
  
  //not present in table
  private int count =-1; 
  
  private float x;
  
  private float y;
  
  private float dia;
  
  private boolean buttonState;
  
  private Boolean stateLevel=null;
  
  private Boolean countyLevel=null;
  
  private Integer stateCount=-1;
 
  //not present in table

  public DataBean() {
    this.buttonState = false;
  }

  public int get_Year_() {
   return this._Year_; 
  }
  
  public void set_Year_(int _Year_) {
    this._Year_ = _Year_;
  }
  
  public int get_Age_() {
    return this._Age_;
  }

  public void set_Age_(int _Age_) {
    this._Age_ = _Age_;
  }

  public int get_Alcohol_() {
    return this._Alcohol_;
  }

  public void set_Alcohol_(int _Alcohol_) {
    this._Alcohol_ = _Alcohol_;
  }

  public int get_BodyType_() {
    return this._BodyType_;
  }

  public void set_BodyType_(int _BodyType_) {
    this._BodyType_ = _BodyType_;
  }

  public int get_CaseNumber_() {
    return this._CaseNumber_;
  }

  public void set_CaseNumber_(int _CaseNumber_) {
    this._CaseNumber_ = _CaseNumber_;
  }

  public int get_City_() {
    return this._City_;
  }

  public void set_City_(int _City_) {
    this._City_ = _City_;
  }

  public int get_County_() {
    return this._County_;
  }

  public void set_County_(int _County_) {
    this._County_ = _County_;
  }

  public int get_CrashDate_() {
    return this._CrashDate_;
  }

  public void set_CrashDate_(int _CrashDate_) {
    this._CrashDate_ = _CrashDate_;
  }

  public int get_CrashFactor_() {
    return this._CrashFactor_;
  }

  public void set_CrashFactor_(int _CrashFactor_) {
    this._CrashFactor_ = _CrashFactor_;
  }

  public int get_CrashHour_() {
    return this._CrashHour_;
  }

  public void set_CrashHour_(int _CrashHour_) {
    this._CrashHour_ = _CrashHour_;
  }

  public int get_DriverFactors_() {
    return this._DriverFactors_;
  }

  public void set_DriverFactors_(int _DriverFactors_) {
    this._DriverFactors_ = _DriverFactors_;
  }

  public int get_Fatalities_() {
    return this._Fatalities_;
  }

  public void set_Fatalities_(int _Fatalities_) {
    this._Fatalities_ = _Fatalities_;
  }

  public int get_HolidayRelated_() {
    return this._HolidayRelated_;
  }

  public void set_HolidayRelated_(int _HolidayRelated_) {
    this._HolidayRelated_ = _HolidayRelated_;
  }

  public int get_Id_() {
    return this._Id_;
  }

  public void set_Id_(int _Id_) {
    this._Id_ = _Id_;
  }

  public int get_InjurySeverity_() {
    return this._InjurySeverity_;
  }

  public void set_InjurySeverity_(int _InjurySeverity_) {
    this._InjurySeverity_ = _InjurySeverity_;
  }

  public float get_Latitude_() {
    return this._Latitude_;
  }

  public void set_Latitude_(float _Latitude_) {
    this._Latitude_ = _Latitude_;
  }

  public int get_LicenseState_() {
    return this._LicenseState_;
  }

  public void set_LicenseState_(int _LicenseState_) {
    this._LicenseState_ = _LicenseState_;
  }

  public int get_LightCondition_() {
    return this._LightCondition_;
  }

  public void set_LightCondition_(int _LightCondition_) {
    this._LightCondition_ = _LightCondition_;
  }

  public float get_Longitude_() {
    return this._Longitude_;
  }

  public void set_Longitude_( float _Longitude_) {
    this._Longitude_ = _Longitude_;
  }

  public int get_MannerOfCollision_() {
    return this._MannerOfCollision_;
  }

  public void set_MannerOfCollision_(int _MannerOfCollision_) {
    this._MannerOfCollision_ = _MannerOfCollision_;
  }

  public int get_NationalHighway_() {
    return this._NationalHighway_;
  }

  public void set_NationalHighway_(int _NationalHighway_) {
    this._NationalHighway_ = _NationalHighway_;
  }

  public int get_PersonNumber_() {
    return this._PersonNumber_;
  }

  public void set_PersonNumber_(int _PersonNumber_) {
    this._PersonNumber_ = _PersonNumber_;
  }

  public int get_PersonType_() {
    return this._PersonType_;
  }

  public void set_PersonType_(int _PersonType_) {
    this._PersonType_ = _PersonType_;
  }

  public int get_PreviousAccidents_() {
    return this._PreviousAccidents_;
  }

  public void set_PreviousAccidents_(int _PreviousAccidents_) {
    this._PreviousAccidents_ = _PreviousAccidents_;
  }

  public int get_RoadwaySurface_() {
    return this._RoadwaySurface_;
  }

  public void set_RoadwaySurface_(int _RoadwaySurface_) {
    this._RoadwaySurface_ = _RoadwaySurface_;
  }

  public int get_Sex_() {
    return this._Sex_;
  }

  public void set_Sex_(int _Sex_) {
    this._Sex_ = _Sex_;
  }

  public int get_SpeedLimit_() {
    return this._SpeedLimit_;
  }

  public void set_SpeedLimit_(int _SpeedLimit_) {
    this._SpeedLimit_ = _SpeedLimit_;
  }

  public int get_State_() {
    return this._State_;
  }

  public void set_State_(int _State_) {
    this._State_ = _State_;
  }

  public int get_TravelSpeed_() {
    return this._TravelSpeed_;
  }

  public void set_TravelSpeed_(int _TravelSpeed_) {
    this._TravelSpeed_ = _TravelSpeed_;
  }

  public int get_VehicleFactors_() {
    return this._VehicleFactors_;
  }

  public void set_VehicleFactors_(int _VehicleFactors_) {
    this._VehicleFactors_ = _VehicleFactors_;
  }

  public int get_VehicleMake_() {
    return this._VehicleMake_;
  }

  public void set_VehicleMake_(int _VehicleMake_) {
    this._VehicleMake_ = _VehicleMake_;
  }

  public int get_VehicleNumber_() {
    return this._VehicleNumber_;
  }

  public void set_VehicleNumber_(int _VehicleNumber_) {
    this._VehicleNumber_ = _VehicleNumber_;
  }

  public int get_Weather_() {
    return this._Weather_;
  }

  public void set_Weather_(int _Weather_) {
    this._Weather_ = _Weather_;
  }
  
  
  void resetButton()
  {
    buttonState = false;
  }
  
  boolean updateButton(float touchx, float touchy) //TODO - REPLACE MOUSEX AND MOUSEY
  {
    float disX =  x - touchx;
    float disY =  y - touchy;
    if(sqrt(sq(disX) + sq(disY)) < dia/2 )
    {
      if(buttonState)
      {
        buttonState = false;
      }
      else
      {
        for(DataBean b : pointList)
          b.resetButton();
        buttonState = true; 
      }
    }
    return buttonState;
  }
}
