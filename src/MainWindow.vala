/*-
 * Copyright (c) 2017-2018 Subhadeep Jasu <subhajasu@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 *              Saunak Biswas  <saunakbis97@gmail.com>
 */
 
namespace Pebbles {
    public class MainWindow : Gtk.Window {
        
        // CONTROLS
        Gtk.HeaderBar headerbar;
        Granite.ModeSwitch dark_mode_switch;
        Pebbles.Settings settings;
        Gtk.Button angle_unit_button;
        Gtk.Grid shift_grid;
        Gtk.Label shift_label;
        Gtk.Switch shift_switch;
        
        // VIEWS
        Pebbles.ScientificView scientific_view;
        Pebbles.ProgrammerView programmer_view;
        Pebbles.CalculusView calculus_view;
        
        public MainWindow () {
            load_settings ();
            make_ui ();
        }
        
        construct {
            settings = Pebbles.Settings.get_default ();
            settings.notify["use-dark-theme"].connect (() => {
                Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = settings.use_dark_theme;
            });
            this.delete_event.connect (() => {
                save_settings ();
            });
        }
        
        public void make_ui () {
        
            // Create dark mode switcher
            dark_mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            dark_mode_switch.primary_icon_tooltip_text = ("Light background");
            dark_mode_switch.secondary_icon_tooltip_text = ("Dark background");
            dark_mode_switch.valign = Gtk.Align.CENTER;
            dark_mode_switch.active = settings.use_dark_theme;
            dark_mode_switch.notify["active"].connect (() => {
                settings.use_dark_theme = dark_mode_switch.active;
            });
            
            // Create angle unit button
            angle_unit_button = new Gtk.Button.with_label ("DEG");
            angle_unit_button.margin = 12;
            angle_unit_button_label_update ();
            angle_unit_button.clicked.connect (() => {
                settings.switch_angle_unit ();
                angle_unit_button_label_update ();
            });
            
            // Create shift switcher
            shift_grid = new Gtk.Grid ();
            shift_label = new Gtk.Label ("\tShift ");
            shift_switch = new Gtk.Switch ();
            shift_switch.get_style_context ().add_class (Granite.STYLE_CLASS_MODE_SWITCH);
            shift_grid.attach (shift_label, 0, 0, 1, 1);
            shift_grid.attach (shift_switch, 1, 0, 1, 1);
            shift_grid.valign = Gtk.Align.CENTER;
            shift_grid.column_spacing = 6;
            
            // Create headerbar
            headerbar = new Gtk.HeaderBar ();
            headerbar.title = ("Pebbles");
            headerbar.get_style_context ().add_class ("default-decoration");
            headerbar.show_close_button = true;
            headerbar.pack_start (angle_unit_button);
            headerbar.pack_start (shift_grid);
            headerbar.pack_end (dark_mode_switch);
            this.set_titlebar (headerbar);
            
            // Create Item Pane
            var scientific_item = new Granite.Widgets.SourceList.Item ("Scientific");
            var programmer_item = new Granite.Widgets.SourceList.Item ("Programmer");
            var calculus_item   = new Granite.Widgets.SourceList.Item ("Calculus");
            
            var calc_category = new Granite.Widgets.SourceList.ExpandableItem ("Calculator");
            calc_category.expand_all ();
            calc_category.add (scientific_item);
            calc_category.add (programmer_item);
            calc_category.add (calculus_item);
            
            var item_list = new Granite.Widgets.SourceList ();
            item_list.root.add (calc_category);
            
            // Create Views
            scientific_view = new Pebbles.ScientificView ();
            programmer_view = new Pebbles.ProgrammerView ();
            calculus_view   = new Pebbles.CalculusView ();
            
            // Create Views Pane
            var common_view = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            common_view.valign = Gtk.Align.CENTER;
            common_view.halign = Gtk.Align.CENTER;
            common_view.add (scientific_view);

            //Create Panes
            var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            paned.position = 120;
            paned.position_set = true;
            paned.pack1 (item_list, false, false);
            paned.pack2 (common_view, false, false);

            // Create View Events
            item_list.item_selected.connect ((item) => {
                if (item == scientific_item) {
                    common_view.foreach ((element) => common_view.remove (element));
                    common_view.add (scientific_view);
                }
                else if (item == programmer_item) {
                    common_view.foreach ((element) => common_view.remove (element));
                    common_view.add (programmer_view);
                }
                else if (item == calculus_item) {
                    common_view.foreach ((element) => common_view.remove (element));
                    common_view.add (calculus_view);
                }
                this.show_all ();
            });
            scientific_item.activated ();

            // Set up window attributes
            this.set_default_size (900, 600);
            this.set_size_request (900, 600);
            input_handler ();

            // Show all the stuff
            this.add (paned);
            this.set_resizable (false);
            this.show_all ();
        }
        private void input_handler () {
            this.key_press_event.connect ((event) => {
                scientific_view.handle_inputs (event.str);
                return true;
            });
        }
        private void angle_unit_button_label_update () {
            if (settings.global_angle_unit == Pebbles.GlobalAngleUnit.DEG) {
                angle_unit_button.label = "DEG";
            }
            else if (settings.global_angle_unit == Pebbles.GlobalAngleUnit.RAD) {
                angle_unit_button.label = "RAD";
            }
            else if (settings.global_angle_unit == Pebbles.GlobalAngleUnit.GRAD) {
                angle_unit_button.label = "GRA";
            }
        }
        private void load_settings () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = settings.use_dark_theme;
            if (settings.window_x < 0 || settings.window_y < 0 ) {
                this.window_position = Gtk.WindowPosition.CENTER;
            } else {
                this.move (settings.window_x, settings.window_y);
            }
        }
        
        private void save_settings () {
            int x, y;
            this.get_position (out x, out y);
            settings.window_x = x;
            settings.window_y = y;
        }

    }
}
