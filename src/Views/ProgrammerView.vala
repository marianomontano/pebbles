/*-
 * Copyright (c) 2017-2020 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2017-2020 Saunak Biswas <saunakbis97@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 */

namespace Pebbles {
    public class ProgrammerView : Gtk.Overlay {
        // Reference of main window
        public MainWindow window;

        // Fake LCD display
        Gtk.Box display_container;
        public ProgrammerDisplay display_unit;

        // Input section left side
        Gtk.Grid button_container_left;

        // Input section right side
        Gtk.Grid button_container_right;

        // Input section left buttons
        StyledButton all_clear_button;
        Gtk.Button del_button;
        StyledButton seven_button;
        StyledButton eight_button;
        StyledButton nine_button;
        StyledButton a_button;
        StyledButton d_button;
        StyledButton div_button;
        StyledButton four_button;
        StyledButton five_button;
        StyledButton six_button;
        StyledButton b_button;
        StyledButton e_button;
        StyledButton multi_button;
        StyledButton one_button;
        StyledButton two_button;
        StyledButton three_button;
        StyledButton c_button;
        StyledButton f_button;
        StyledButton minus_button;
        StyledButton zero_button;
        StyledButton left_parenthesis_button;
        StyledButton right_parenthesis_button;
        Gtk.Button   bit_button;
        StyledButton lsh_rsh_button;
        StyledButton plus_button;
        Granite.Widgets.ModeButton bit_mode_button;

        // Input section right buttons
        StyledButton or_button;
        StyledButton memory_plus_button;
        StyledButton and_button;
        StyledButton memory_minus_button;
        StyledButton xor_button;
        StyledButton memory_recall_button;
        StyledButton not_button;
        StyledButton memory_clear_button;
        public StyledButton ans_button;
        StyledButton result_button;
        
        // Bit Toggle View
        public BitToggleGrid bit_grid;

        // App Settings
        Pebbles.Settings settings;

        private bool shift_held = false;

        public ProgrammerView (MainWindow window) {
            this.window = window;
            settings = Settings.get_default ();
            // Make UI
            prog_make_ui ();
            prog_make_events ();
        }

        public void prog_make_ui () {

            var main_grid = new Gtk.Grid ();

            // Make fake LCD display
            display_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            display_container.height_request = 120;
            display_container.width_request = 560;
            display_container.margin_start = 8;
            display_container.margin_end = 8;
            display_container.margin_top = 8;
            display_container.margin_bottom = 8;
            display_unit = new ProgrammerDisplay (this);
            display_container.pack_start (display_unit);

            // Make Input section on the left
            button_container_left = new Gtk.Grid ();
            button_container_left.height_request = 250;
            button_container_left.margin_start = 8;
            button_container_left.margin_end = 7;
            button_container_left.margin_bottom = 8;
            button_container_left.column_spacing = 8;
            button_container_left.row_spacing = 8;

            // Make Input section on the right
            button_container_right = new Gtk.Grid ();
            button_container_right.height_request = 250;
            button_container_right.margin_start = 4;
            button_container_right.margin_end = 8;
            button_container_right.margin_bottom = 8;
            button_container_right.column_spacing = 8;
            button_container_right.row_spacing = 8;

            // Make buttons on the left
            all_clear_button = new StyledButton ("AC", "All Clear");
            all_clear_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            del_button = new Gtk.Button.from_icon_name ("edit-clear-symbolic", Gtk.IconSize.BUTTON);
            del_button.set_tooltip_text (_("Backspace"));
            if (display_unit.input_entry.get_text () =="0" || display_unit.input_entry.get_text () == "") {
                del_button.sensitive = false;
            } else {
                del_button.sensitive = true;
            }
            display_unit.input_entry.changed.connect (() => {
                if (display_unit.input_entry.get_text () == "0" || display_unit.input_entry.get_text () == "")
                    del_button.sensitive = false;
                else
                    del_button.sensitive = true;
            });
            seven_button = new StyledButton ("7");
            eight_button = new StyledButton ("8");
            nine_button  = new StyledButton ("9");
            a_button     = new StyledButton ("A");
            a_button.set_sensitive (false);
            d_button     = new StyledButton ("D");
            d_button.set_sensitive (false);
            div_button   = new StyledButton ("\xC3\xB7");
            div_button.get_style_context ().add_class ("h3");
            four_button  = new StyledButton ("4");
            five_button  = new StyledButton ("5");
            six_button   = new StyledButton ("6");
            b_button     = new StyledButton ("B");
            b_button.set_sensitive (false);
            e_button     = new StyledButton ("E");
            e_button.set_sensitive (false);
            multi_button = new StyledButton ("\xC3\x97");
            multi_button.get_style_context ().add_class ("h3");
            one_button   = new StyledButton ("1");
            two_button   = new StyledButton ("2");
            three_button = new StyledButton ("3");
            c_button     = new StyledButton ("C");
            c_button.set_sensitive (false);
            f_button     = new StyledButton ("F");
            f_button.set_sensitive (false);
            minus_button = new StyledButton ("\xE2\x88\x92");
            minus_button.get_style_context ().add_class ("h3");
            zero_button  = new StyledButton ("0");
            left_parenthesis_button = new StyledButton ("(");
            right_parenthesis_button = new StyledButton (")");
            bit_button   = new Gtk.Button.from_icon_name ("view-grid-symbolic", Gtk.IconSize.BUTTON);
            bit_button.tooltip_text = "Bit toggle grid";
            lsh_rsh_button = new StyledButton ("Lsh", "Left Shift");
            plus_button  = new StyledButton ("+");
            plus_button.get_style_context ().add_class ("h3");
            
            bit_mode_button = new Granite.Widgets.ModeButton ();
            bit_mode_button.append_text ("  HEXA  ");
            bit_mode_button.append_text ("DECI");
            bit_mode_button.append_text ("OCTL");
            bit_mode_button.append_text ("BNRY");
            switch (settings.number_system) {
                case NumberSystem.BINARY:
                bit_mode_button.set_active  (3);
                set_keypad_mode(3);
                break;
                case NumberSystem.OCTAL:
                bit_mode_button.set_active  (2);
                set_keypad_mode(2);
                break;
                case NumberSystem.DECIMAL:
                bit_mode_button.set_active  (1);
                set_keypad_mode(1);
                break;
                case NumberSystem.HEXADECIMAL:
                bit_mode_button.set_active  (0);
                set_keypad_mode(0);
                break;
            }

            // Make buttons on the right
            or_button = new StyledButton ("Or", "Logical OR (TRUE for any input being TRUE)");
            or_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            memory_plus_button = new StyledButton ("   M+   ", "Add it to the value in Memory");
            memory_plus_button.get_style_context ().add_class ("Pebbles_Buttons_Memory");
            and_button = new StyledButton (" And ", "Logical AND (TRUE for all inputs being TRUE)");
            and_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            memory_minus_button = new StyledButton ("M-", "Subtract it from the value in Memory");
            memory_minus_button.get_style_context ().add_class ("Pebbles_Buttons_Memory");
            xor_button = new StyledButton ("Xor", "Logical Exclusive-OR (TRUE for exactly one input being TRUE)");
            xor_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            memory_recall_button = new StyledButton ("MR", "Recall value from Memory");
            memory_recall_button.get_style_context ().add_class ("Pebbles_Buttons_Memory");
            not_button = new StyledButton ("Not", "Logical Inverter (TRUE for input being FALSE and vice versa)");
            not_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            memory_clear_button = new StyledButton ("MC", "Memory Clear");
            memory_clear_button.get_style_context ().add_class ("Pebbles_Buttons_Memory");
            ans_button = new StyledButton ("Ans", "Last answer");
            ans_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            ans_button.set_sensitive (false);
            result_button = new StyledButton ("=", "Result");
            result_button.get_style_context ().add_class ("h2");
            result_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            

            button_container_left.attach (all_clear_button, 0, 0, 1, 1);
            button_container_left.attach (del_button, 1, 0, 1, 1);
            button_container_left.attach (bit_mode_button, 2, 0, 4, 1);
            button_container_left.attach (seven_button, 0, 1, 1, 1);
            button_container_left.attach (eight_button, 1, 1, 1, 1);
            button_container_left.attach (nine_button, 2, 1, 1, 1);
            button_container_left.attach (a_button, 3, 1, 1, 1);
            button_container_left.attach (d_button, 4, 1, 1, 1);
            button_container_left.attach (div_button, 5, 1, 1, 1);
            button_container_left.attach (four_button, 0, 2, 1, 1);
            button_container_left.attach (five_button, 1, 2, 1, 1);
            button_container_left.attach (six_button, 2, 2, 1, 1);
            button_container_left.attach (b_button, 3, 2, 1, 1);
            button_container_left.attach (e_button, 4, 2, 1, 1);
            button_container_left.attach (multi_button, 5, 2, 1, 1);
            button_container_left.attach (one_button, 0, 3, 1, 1);
            button_container_left.attach (two_button, 1, 3, 1, 1);
            button_container_left.attach (three_button, 2, 3, 1, 1);
            button_container_left.attach (c_button, 3, 3, 1, 1);
            button_container_left.attach (f_button,4 ,3, 1, 1);
            button_container_left.attach (minus_button,5, 3, 1, 1);
            button_container_left.attach (zero_button,0, 4, 1, 1);
            button_container_left.attach (left_parenthesis_button, 1, 4, 1, 1);
            button_container_left.attach (right_parenthesis_button, 2, 4, 1, 1);
            button_container_left.attach (bit_button, 3, 4, 1 ,1);
            button_container_left.attach (lsh_rsh_button, 4, 4, 1, 1);
            button_container_left.attach (plus_button, 5, 4, 1, 1);
            
            button_container_left.set_column_homogeneous (true);
            button_container_left.set_row_homogeneous (true);
            

            button_container_right.attach (or_button,           0, 0, 1, 1);
            button_container_right.attach (memory_plus_button,  1, 0, 1, 1);
            button_container_right.attach (and_button,          0, 1, 1, 1);
            button_container_right.attach (memory_minus_button, 1, 1, 1, 1);
            button_container_right.attach (xor_button,          0, 2, 1, 1);
            button_container_right.attach (memory_recall_button,1, 2, 1, 1);
            button_container_right.attach (not_button,          0, 3, 1, 1);
            button_container_right.attach (memory_clear_button, 1, 3, 1, 1);
            button_container_right.attach (ans_button,          0, 4, 1, 1);
            button_container_right.attach (result_button,       1, 4, 1, 1);
            
            button_container_right.set_column_homogeneous (true);
            button_container_right.set_row_homogeneous (true);
            
            var main_keypad_grid = new Gtk.Grid ();
            main_keypad_grid.attach (button_container_left, 0, 0, 1, 1);
            main_keypad_grid.attach (button_container_right,1, 0, 1, 1);
            
            bit_grid = new BitToggleGrid ();
            
            var keypad_stack = new Gtk.Stack ();
            keypad_stack.add_named (main_keypad_grid, "Main Numeric Keypad");
            keypad_stack.add_named (bit_grid, "Bit Toggle Grid");
            keypad_stack.set_transition_type (Gtk.StackTransitionType.OVER_UP_DOWN);
            bit_button.clicked.connect (() => {
                keypad_stack.set_visible_child (bit_grid);
            });
            bit_grid.hide_grid.clicked.connect (() => {
                keypad_stack.set_visible_child (main_keypad_grid);
            });
            
            main_grid.attach (display_container, 0, 0, 1, 1);
            main_grid.attach (keypad_stack, 0, 1, 1, 1);
            main_grid.width_request = 500;
            //main_grid.set_column_homogeneous (true);
            
            add_overlay (main_grid);
        }
        public void hold_shift (bool hold) {
            shift_held = hold;
            display_unit.set_shift_enable (hold);
            set_alternative_button ();
        }
        public void set_alternative_button () {
            if (shift_held) {
                or_button.update_label ("Nor", "Logical NOT-of-OR (TRUE only for all inputs being FALSE)");
                and_button.update_label ("Nand", "Logical NOT-of-AND (FALSE only for all inputs being TRUE)");
                xor_button.update_label ("Xnor", "Logical NOT-of-XOR (TRUE only for all inputs being same)");
                not_button.update_label ("Mod", "Modulus");
                lsh_rsh_button.update_label ("Rsh", "Right Shift");
            }
            else {
                or_button.update_label      ("Or", "Logical OR (TRUE for any input being TRUE)");
                and_button.update_label     ("And", "Logical AND (TRUE for all inputs being TRUE)");
                xor_button.update_label     ("Xor", "Logical Exclusive-OR (TRUE for exactly one input being TRUE)");
                not_button.update_label     ("Not", "Logical Inverter (TRUE for input being FALSE and vice versa)");
                lsh_rsh_button.update_label ("Lsh", "Left Shift");
            }
        }
        private void prog_make_events () {
            bit_mode_button.mode_changed.connect (() => {
                if (bit_mode_button.selected == 0) {
                    settings.number_system = NumberSystem.HEXADECIMAL;
                }
                else if (bit_mode_button.selected == 1){
                    settings.number_system = NumberSystem.DECIMAL;
                }
                else if (bit_mode_button.selected == 2){
                    settings.number_system = NumberSystem.OCTAL;
                }
                else if (bit_mode_button.selected == 3){
                    settings.number_system = NumberSystem.BINARY;
                }
                display_unit.set_number_system ();
                set_keypad_mode (bit_mode_button.selected);
                display_unit.input_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
            });
            display_unit.set_number_system ();

            result_button.button_press_event.connect ((event) => {
                display_unit.display_off ();
                return false;
            });
            result_button.button_release_event.connect (() => {
                display_unit.display_on ();
                display_unit.get_answer_evaluate ();
                return false;
            });
            all_clear_button.clicked.connect (() => {
                display_unit.input_entry.grab_focus_without_selecting ();
                display_unit.input_entry.set_text ("0");
                display_unit.input_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
            });
            del_button.clicked.connect (() => {
                display_unit.input_entry.grab_focus_without_selecting ();
                display_unit.send_backspace ();
            });
            div_button.clicked.connect (() => {
                display_unit.insert_text (" ÷ ");
            });
            seven_button.clicked.connect (() => {
                display_unit.insert_text ("7");
            });
            eight_button.clicked.connect (() => {;
                display_unit.insert_text ("8");
            });
            nine_button.clicked.connect (() => {;
                display_unit.insert_text ("9");
            });
            multi_button.clicked.connect (() => {;
                display_unit.insert_text (" × ");
            });
            four_button.clicked.connect (() => {;
                display_unit.insert_text ("4");
            });
            five_button.clicked.connect (() => {;
                display_unit.insert_text ("5");
            });
            six_button.clicked.connect (() => {;
                display_unit.insert_text ("6");
            });
            minus_button.clicked.connect (() => {;
                display_unit.insert_text (" - ");
            });
            one_button.clicked.connect (() => {;
                display_unit.insert_text ("1");
            });
            two_button.clicked.connect (() => {;
                display_unit.insert_text ("2");
            });
            three_button.clicked.connect (() => {;
                display_unit.insert_text ("3");
            });
            plus_button.clicked.connect (() => {;
                display_unit.insert_text (" + ");
            });
            zero_button.clicked.connect (() => {;
                display_unit.insert_text ("0");
            });
            a_button.clicked.connect (() => {;
                display_unit.insert_text ("a");
            });
            b_button.clicked.connect (() => {;
                display_unit.insert_text ("b");
            });
            c_button.clicked.connect (() => {;
                display_unit.insert_text ("c");
            });
            d_button.clicked.connect (() => {;
                display_unit.insert_text ("d");
            });
            e_button.clicked.connect (() => {;
                display_unit.insert_text ("e");
            });
            f_button.clicked.connect (() => {;
                display_unit.insert_text ("f");
            });
            left_parenthesis_button.clicked.connect (() => {;
                display_unit.insert_text ("( ");
            });
            right_parenthesis_button.clicked.connect (() => {;
                display_unit.insert_text (" ) ");
            });
            or_button.clicked.connect (() => {
                if (shift_held)
                    display_unit.insert_text (" nor ");
                else
                    display_unit.insert_text (" or ");
            });
            and_button.clicked.connect (() => {
                if (shift_held)
                    display_unit.insert_text (" nand ");
                else
                    display_unit.insert_text (" and ");
            });
            xor_button.clicked.connect (() => {
                if (shift_held)
                    display_unit.insert_text (" xnor ");
                else
                    display_unit.insert_text (" xor ");
            });
            not_button.clicked.connect (() => {
                if (shift_held)
                    display_unit.insert_text (" mod ");
                else
                    display_unit.insert_text (" not ");
            });
            lsh_rsh_button.clicked.connect (()=> {
                if (shift_held)
                    display_unit.insert_text (" rsh ");
                else
                    display_unit.insert_text (" lsh ");
            });
            memory_plus_button.button_press_event.connect ((event) => {
                if (event.button == 1) {
                    display_unit.display_off ();
                    display_unit.get_answer_evaluate ();
                    if (display_unit.input_entry.get_text ().length == 0 && display_unit.input_entry.get_text () != "0") {
                        display_unit.input_entry.set_text ("0");
                    }
                    display_unit.input_entry.grab_focus_without_selecting ();
                    if (display_unit.input_entry.cursor_position < display_unit.input_entry.get_text ().length)
                        display_unit.input_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                    if (display_unit.answer_label.get_text () != "Error") {
                        display_unit.memory_append (false);
                    }
                }
                return false;
            });
            memory_plus_button.button_release_event.connect (() => {
                display_unit.display_on ();
                return false;
            });
            memory_minus_button.button_press_event.connect ((event) => {
                if (event.button == 1) {
                    display_unit.display_off ();
                    display_unit.get_answer_evaluate ();
                    if (display_unit.input_entry.get_text ().length == 0 && display_unit.input_entry.get_text () != "0") {
                        display_unit.input_entry.set_text ("0");
                    }
                    display_unit.input_entry.grab_focus_without_selecting ();
                    if (display_unit.input_entry.cursor_position < display_unit.input_entry.get_text ().length)
                        display_unit.input_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                    if (display_unit.answer_label.get_text () != "Error") {
                        display_unit.memory_append (true);
                    }
                }
                return false;
            });
            memory_minus_button.button_release_event.connect (() => {
                display_unit.display_on ();
                return false;
            });

            memory_recall_button.clicked.connect (() => {
                display_unit.memory_recall ();
            });

            memory_clear_button.button_press_event.connect ((event) => {
                display_unit.display_off ();
                return false;
            });
            memory_clear_button.button_release_event.connect (() => {
                display_unit.display_on ();
                display_unit.memory_clear ();
                return false;
            });

            ans_button.clicked.connect (() => {
                display_unit.insert_text ("ans ");
            });

            bit_grid.changed.connect ((arr) => {
                display_unit.set_last_token_from_bit_grid (arr);
            });

            display_unit.last_token_changed.connect ((arr) => {
                bit_grid.set_bits (arr);
            });
        }
        public void key_pressed (Gdk.EventKey event) {
            switch (event.keyval) {
                case KeyboardHandler.KeyMap.BACKSPACE:
                if (del_button.get_sensitive ()) {
                    display_unit.send_backspace ();
                    del_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_7: // 7 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_7:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("7");
                    seven_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_8: // 8 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_8:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL
                 || settings.number_system == Pebbles.NumberSystem.DECIMAL) {
                    display_unit.insert_text ("8");
                    eight_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_9: // 9 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_9:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL
                 || settings.number_system == Pebbles.NumberSystem.DECIMAL) {
                    display_unit.insert_text ("9");
                    nine_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_4: // 4 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_4:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("4");
                    four_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_5: // 5 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_5:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("5");
                    five_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_6: // 6 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_6:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("6");
                    six_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_1: // 1 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_1:
                display_unit.insert_text ("1");
                one_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.NUMPAD_2: // 2 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_2:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("2");
                    two_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_3: // 3 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_3:
                if (settings.number_system != Pebbles.NumberSystem.BINARY) {
                    display_unit.insert_text ("3");
                    three_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.NUMPAD_0: // 0 key numpad
                case KeyboardHandler.KeyMap.KEYPAD_0:
                display_unit.insert_text ("0");
                zero_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.A_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.A_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("a");
                    a_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.B_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.B_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("b");
                    b_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.C_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.C_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("c");
                    c_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.D_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.D_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("d");
                    d_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.E_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.E_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("e");
                    e_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.F_LOWER: // 0 key numpad
                case KeyboardHandler.KeyMap.F_UPPER:
                if (settings.number_system == Pebbles.NumberSystem.HEXADECIMAL) {
                    display_unit.insert_text ("f");
                    f_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                }
                break;
                case KeyboardHandler.KeyMap.DELETE:
                display_unit.input_entry.grab_focus_without_selecting ();
                display_unit.input_entry.set_text ("0");
                display_unit.input_entry.move_cursor (Gtk.MovementStep.DISPLAY_LINE_ENDS, 0, false);
                all_clear_button.get_style_context ().add_class ("Pebbles_Buttons_Destructive_Pressed");
                break;
                case KeyboardHandler.KeyMap.PLUS_NUMPAD:
                case KeyboardHandler.KeyMap.PLUS_KEYPAD:
                display_unit.insert_text (" + ");
                plus_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.MINUS_NUMPAD:
                case KeyboardHandler.KeyMap.MINUS_KEYPAD:
                display_unit.insert_text (" - ");
                minus_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.SLASH_NUMPAD:
                case KeyboardHandler.KeyMap.SLASH_KEYPAD:
                display_unit.insert_text (" ÷ ");
                div_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.STAR_NUMPAD:
                case KeyboardHandler.KeyMap.STAR_KEYPAD:
                display_unit.insert_text (" × ");
                multi_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                break;
                case KeyboardHandler.KeyMap.O_LOWER:
                display_unit.insert_text (" or ");
                break;
                case KeyboardHandler.KeyMap.N_LOWER:
                display_unit.insert_text (" and ");
                break;
                case KeyboardHandler.KeyMap.X_LOWER:
                display_unit.insert_text (" xor ");
                break;
                case KeyboardHandler.KeyMap.T_LOWER:
                case KeyboardHandler.KeyMap.I_LOWER:
                case KeyboardHandler.KeyMap.I_UPPER:
                display_unit.insert_text (" not ");
                break;
                case KeyboardHandler.KeyMap.O_UPPER:
                display_unit.insert_text (" nor ");
                break;
                case KeyboardHandler.KeyMap.N_UPPER:
                display_unit.insert_text (" nand ");
                break;
                case KeyboardHandler.KeyMap.X_UPPER:
                display_unit.insert_text (" xnor ");
                break;
                case KeyboardHandler.KeyMap.T_UPPER:
                case KeyboardHandler.KeyMap.M_UPPER:
                case KeyboardHandler.KeyMap.M_LOWER:
                display_unit.insert_text (" mod ");
                break;
                case KeyboardHandler.KeyMap.PARENTHESIS_L:
                case KeyboardHandler.KeyMap.SQ_BRACKETS_L:
                case KeyboardHandler.KeyMap.FL_BRACKETS_L:
                left_parenthesis_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                display_unit.insert_text ("( ");
                break;
                case KeyboardHandler.KeyMap.PARENTHESIS_R:
                case KeyboardHandler.KeyMap.SQ_BRACKETS_R:
                case KeyboardHandler.KeyMap.FL_BRACKETS_R:
                right_parenthesis_button.get_style_context ().add_class ("Pebbles_Buttons_Pressed");
                display_unit.insert_text (" ) ");
                break;
            }
        }
        public void key_released (Gdk.EventKey event) {
            display_unit.display_on ();
            left_parenthesis_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            right_parenthesis_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            del_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            seven_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            eight_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            nine_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            four_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            five_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            six_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            one_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            two_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            three_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            zero_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            a_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            b_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            c_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            d_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            e_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            f_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");

            plus_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            minus_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            div_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
            multi_button.get_style_context ().remove_class ("Pebbles_Buttons_Pressed");
        }
        private void set_keypad_mode (int mode) {
            switch (mode) {
                case 0:
                    seven_button.set_sensitive (true);
                    eight_button.set_sensitive (true);
                    nine_button.set_sensitive (true);
                    a_button.set_sensitive (true);
                    d_button.set_sensitive (true);
                    four_button.set_sensitive (true);
                    five_button.set_sensitive (true);
                    six_button.set_sensitive (true);
                    b_button.set_sensitive (true);
                    e_button.set_sensitive (true);
                    two_button.set_sensitive (true);
                    three_button.set_sensitive (true);
                    c_button.set_sensitive (true);
                    f_button.set_sensitive (true);
                    break;
                case 1:
                    seven_button.set_sensitive (true);
                    eight_button.set_sensitive (true);
                    nine_button.set_sensitive (true);
                    a_button.set_sensitive (false);
                    d_button.set_sensitive (false);
                    four_button.set_sensitive (true);
                    five_button.set_sensitive (true);
                    six_button.set_sensitive (true);
                    b_button.set_sensitive (false);
                    e_button.set_sensitive (false);
                    two_button.set_sensitive (true);
                    three_button.set_sensitive (true);
                    c_button.set_sensitive (false);
                    f_button.set_sensitive (false);
                    break;
                case 2:
                    seven_button.set_sensitive (true);
                    eight_button.set_sensitive (false);
                    nine_button.set_sensitive (false);
                    a_button.set_sensitive (false);
                    d_button.set_sensitive (false);
                    four_button.set_sensitive (true);
                    five_button.set_sensitive (true);
                    six_button.set_sensitive (true);
                    b_button.set_sensitive (false);
                    e_button.set_sensitive (false);
                    two_button.set_sensitive (true);
                    three_button.set_sensitive (true);
                    c_button.set_sensitive (false);
                    f_button.set_sensitive (false);
                    break;
                case 3:
                    seven_button.set_sensitive (false);
                    eight_button.set_sensitive (false);
                    nine_button.set_sensitive (false);
                    a_button.set_sensitive (false);
                    d_button.set_sensitive (false);
                    four_button.set_sensitive (false);
                    five_button.set_sensitive (false);
                    six_button.set_sensitive (false);
                    b_button.set_sensitive (false);
                    e_button.set_sensitive (false);
                    two_button.set_sensitive (false);
                    three_button.set_sensitive (false);
                    c_button.set_sensitive (false);
                    f_button.set_sensitive (false);
                    break;
            }
        }
    }
}   
