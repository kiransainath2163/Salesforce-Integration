/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-14-2021
 * @last modified by  : kiransainath@apisero.com
 **/
global class ReverseGeoCoding {
    public cls_results[] results;
    public cls_status status;
    public class cls_results {
        public cls_components components;
        public Integer confidence; //9
        public String formatted; //unnamed road, Ward 114 KPHB Colony, Hyderabad - 500085, Telangana, India
        public cls_geometry geometry;
    }
    public class cls_components {
        public String city; //Hyderabad
        public String continent; //Asia
        public String country; //India
        public String country_code; //in
        public String county; //Kukatpally mandal
        public String neighbourhood; //Vasanth Nagar
        public String postcode; //500085
        public String road; //unnamed road
        public String road_type; //residential
        public String state; //Telangana
        public String state_code; //TG
        public String state_district; //Medchal–Malkajgiri
        public String suburb; //Ward 114 KPHB Colony
    }
    public class cls_geometry {
        public Double lat; //17.49517
        public Double lng; //78.3886437
    }
    public class cls_status {
        public Integer code; //200
        public String message; //OK
    }
    public static ReverseGeoCoding parse(String json) {
        return (ReverseGeoCoding) System.JSON.deserialize(
            json,
            ReverseGeoCoding.class
        );
    }
}
