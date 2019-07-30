include <steps.scad>
include <bricks.scad>
include <rocks.scad>

top_wall_layer_gap = 10;
top_wall_brick_count = round(wall_circumference / (straight_brick_width + top_wall_layer_gap));
top_wall_conjunction_height = wall_layer_height * 2;
steps_per_window = 2;
windows_angle = step_angle * steps_per_window;
windows_count = (twists * 360 / windows_angle) - 5;
window_step_offset = 10;
outer_bottom_radius = tower_radius + outer_rock_offset;
outer_bottom_deeping = 0.3;
outer_bottom_deeping_step = 10;

intersection() {
    union() {
        steps(-turn_steps_count, steps_count + 1);
        translate([cos(turn_angle) * tower_radius, -sin(turn_angle) * tower_radius, 0]) rotate([0, 0, turn_angle]) mirror([0, 1, 0]) {
            steps(-turn_steps_count * 2, -turn_steps_count);
            rotate([0, 0, -turn_angle * 2.5]) intersection() {
                wall(360 / step_angle * step_height - step_height);
                cube([tower_radius * 2, tower_radius * 2, arc_height + 360 * step_height / step_angle]);
                rotate([0, 0, 90 - turn_angle]) cube([tower_radius * 2, tower_radius * 2, arc_height + 360 * step_height / step_angle]);
            }
        }
        pillar(outer_wall_height);

        difference() {
            union() {
                difference() {
                    union() {
                        translate([0, 0, (steps_count + 1) * step_height]) roof_arc();
                        wall(outer_wall_height - top_wall_conjunction_height);
                    }
                    for (i = [-1:windows_count - 1])
                        rotate([0, 0, 90 + i * windows_angle]) translate([-inner_arc_radius / 8, -tower_radius + wall_thickness * 4, arc_height + window_step_offset + i * step_height * steps_per_window]) scale([0.3, 0.5, 0.5]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 16) polygon(inner_arc);
                }
                for (i = [-1:windows_count - 1])
                    rotate([0, 0, 90 + i * windows_angle])
                        translate([-inner_arc_radius / 8, -tower_radius + wall_thickness + arc_base_thickness, arc_height + window_step_offset + i * step_height * steps_per_window]) minkowski() {
                            difference() {
                                hull() minkowski() {
                                    scale([0.3, 0.5, 0.5]) rotate([90, 0, 0]) linear_extrude((wall_thickness + arc_base_thickness) * 2) polygon(inner_arc);
                                    sphere(r = wear_arc_radius / 2, $fn = pillar_details, true);
                                }
                                scale([0.3, 0.5, 0.5]) translate([0, wall_thickness, 0]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 12) polygon(inner_arc);
                            }
                            sphere(r = brick_rounding_r, $fn = brick_rounding_details);
                        }
                difference() {
                    translate([-wear_arc_radius / 2, -tower_radius + wall_thickness * 2, 0]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 3) polygon(wear_arc);
                    cylinder(r = tower_inner_radius, h = wear_arc_radius + inner_arc_extra_height, $fn = spiral_details);
                }
            }
            translate([-inner_arc_radius / 2, -tower_radius + wall_thickness * 4, -brick_rounding_r]) rotate([90, 0, 0]) linear_extrude(wall_thickness * 8) polygon(inner_arc);
        }
        translate([0, 0, outer_wall_height - top_wall_conjunction_height]) wall(top_wall_conjunction_height, outer_top_radius = top_wall_radius);
        translate([0, 0, outer_wall_height]) wall(wall_layer_height, bricks_gap = top_wall_layer_gap, outer_radius = top_wall_radius, brick_count = top_wall_brick_count);

    }
    translate([-500, -500, -bottom_thickness]) cube([1000, 1000, 1000]);
}

