hdmi_w = 20.5;
hdmi_l = 30;
hdmi_h =11.2;
hdmi_hole = 11; // diameter of hdmi wire hole

usb_w = 14.65;
usb_l = 35.6;
usb_h = 7.2;

plate_t = 2;
port_space = 5;
plate_h = 14;
plate_w = 100;
port_w = (hdmi_w * 3) + usb_w + (port_space*3);

module hdmi() {
    cube([hdmi_w, hdmi_l, hdmi_h], center=true);
}

module usb() {
    cube([usb_w, usb_l, usb_h], center=true);
}

difference() {
    translate([50-(hdmi_w/2)-port_space,-(usb_l-hdmi_l)/2,0]) cube([plate_w,usb_l+2*plate_t,plate_h],center=true);
    hdmi();
    translate([port_space+hdmi_w,0,0]) hdmi();
    translate([(port_space+hdmi_w)*2,0,0]) hdmi();
    translate([(port_space+hdmi_w)*2+port_space+usb_w,-(usb_l-hdmi_l)/2,0]) usb();
    translate([0,0,500]) cube([1000,1000,1000], center=true);
}