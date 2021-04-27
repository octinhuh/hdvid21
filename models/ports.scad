extra = .2; // this is for tolerances of the printer

hdmi_w = 20.5 + extra;
hdmi_l = 30 + extra;
hdmi_h =11.2 + extra;
hdmi_hole = 11; // diameter of hdmi wire hole

usb_w = 14.65 + extra;
usb_l = 35.6 + extra;
usb_h = 7.2 + extra;

plate_t = 1;
port_space = 5;
plate_h = 15;
plate_w = 100;
plate_l = usb_l - 3;
port_w = (hdmi_w * 3) + usb_w + (port_space*3);

face_w = plate_w;
face_l = 4;
face_h = plate_h + 14;

lip = [.9,1,.9];

module hdmi() {
    cube([hdmi_w, hdmi_l, hdmi_h], center=true);
}

module usb() {
    cube([usb_w, usb_l, usb_h], center=true);
}

rotate([-90,0,0]) difference() {
    union() {
      translate([50-(hdmi_w/2)-port_space,0,0]) cube([plate_w,plate_l,plate_h],center=true);
      // face plate
      translate([50-(hdmi_w/2)-port_space,plate_l/2,0]) rotate([90,0,0]) linear_extrude(height=face_l) hull() {
        translate([-face_w/2,0,0]) circle(d=face_h);
        translate([face_w/2,0,0]) circle(d=face_h);
      }
    }
    hdmi();
    translate([0,-20,0]) hdmi();
    translate([0,20,0]) scale(lip) hdmi();
    translate([port_space+hdmi_w,0,0]) hdmi();
    translate([port_space+hdmi_w,-20,0]) hdmi();
    translate([port_space+hdmi_w,20,0]) scale(lip) hdmi();
    translate([(port_space+hdmi_w)*2,0,0]) hdmi();
    translate([(port_space+hdmi_w)*2,-20,0]) hdmi();
    translate([(port_space+hdmi_w)*2,20,0]) scale(lip) hdmi();
    translate([(port_space+hdmi_w)*2+port_space+usb_w,-(usb_l-hdmi_l)/2,0]) usb();
    translate([(port_space+hdmi_w)*2+port_space+usb_w,-(usb_l-hdmi_l)/2+20,0]) scale(lip) usb();
    //translate([0,0,500]) cube([1000,1000,1000], center=true);
}