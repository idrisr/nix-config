{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.home-assistant;
  haPythonPkgs = pkgs.home-assistant.python.pkgs;

  etekcityEsf551Ble = haPythonPkgs.buildPythonPackage rec {
    pname = "etekcity-esf551-ble";
    version = "0.4.1";
    pyproject = true;

    src = pkgs.fetchPypi {
      pname = "etekcity_esf551_ble";
      inherit version;
      hash = "sha256-1m92ZZ8uCt2RU5/YvxU37RIi5lH8Wk4QJwfO8hz1260=";
    };

    build-system = [ haPythonPkgs.hatchling ];

    dependencies = [
      haPythonPkgs.bleak
      haPythonPkgs."bleak-retry-connector"
    ];

    pythonImportsCheck = [ "etekcity_esf551_ble" ];
  };

  etekcityFitnessScaleBle = pkgs.buildHomeAssistantComponent rec {
    owner = "ronnnnnnnnnnnnn";
    domain = "etekcity_fitness_scale_ble";
    version = "0.4.2";

    src = pkgs.fetchFromGitHub {
      inherit owner;
      repo = domain;
      rev = "v${version}";
      hash = "sha256-7yVmZ9pu1Bbir/1z9bEPZBt47nyJs2oq3nau7U4ZuF4=";
    };

    dependencies = [ etekcityEsf551Ble ];
  };

  wiimPythonPackage = haPythonPkgs.buildPythonPackage {
    pname = "wiim";
    version = "0.1.0";
    format = "wheel";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/df/44/5949a75d8608cd8ff4d69243ef498bb09a006b035dd0ca1d77b9a1397c9a/wiim-0.1.0-py3-none-any.whl";
      hash = "sha256-gMCXo+EixZRXPo3lJfGZWlQdNon1PkGNyp5g03BgieE=";
    };

    dependencies = [ haPythonPkgs."async-upnp-client" ];

    pythonImportsCheck = [ "wiim" ];
  };
in
{
  options = {
    home-assistant = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable home-assistant
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.home-assistant = {
      enable = true;
      openFirewall = false;
      extraPackages = ps: [
        ps."infrared-protocols"
        ps.gtts
        ps.pyatv
        ps.pyipp
        ps."govee-ble"
        wiimPythonPackage
      ];
      extraComponents = [
        "bluetooth"
        "bluetooth_adapters"
        # Components required to complete the onboarding
        "esphome"
        "fan"
        "generic_thermostat"
        "hue"
        "input_number"
        "met"
        "radio_browser"
        "reolink"
        "template"
        "tplink"
        "wiim"
        "zha"
      ];
      customComponents = [ etekcityFitnessScaleBle ];
      customLovelaceModules = [ pkgs.home-assistant-custom-lovelace-modules.apexcharts-card ];
      lovelaceConfig = {
        title = "Home";
        views = [
          {
            title = "Weight";
            path = "weight";
            icon = "mdi:scale-bathroom";
            cards = [
              {
                type = "gauge";
                entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                name = "Goal: 185 lb (range 180-215)";
                min = 180;
                max = 215;
                needle = true;
                severity = {
                  green = 185;
                  yellow = 195;
                  red = 205;
                };
              }
              {
                type = "entities";
                title = "Current metrics";
                show_header_toggle = false;
                entities = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                    name = "Idris Weight";
                  }
                  {
                    entity = "sensor.idris_weight_7d_average";
                    name = "Idris Weight 7d Average";
                  }
                  {
                    entity = "sensor.idris_weight_7d_change";
                    name = "Idris Weight 7d Change";
                  }
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_fat_percentage";
                    name = "Idris Body Fat %";
                  }
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_mass_index";
                    name = "Idris BMI";
                  }
                  {
                    entity = "sensor.idris_steps";
                    name = "Idris Steps";
                  }
                  {
                    entity = "input_number.idris_waist";
                    name = "Idris Waist";
                  }
                ];
              }
              {
                type = "entities";
                title = "Manual entry";
                show_header_toggle = false;
                entities = [
                  {
                    entity = "input_number.idris_waist";
                    name = "Waist (in)";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Idris Weight (30 days)";
                hours_to_show = 720;
                refresh_interval = 0;
                min_y_axis = 180;
                max_y_axis = 215;
                entities = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                    name = "Weight";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Idris Weight (5 days)";
                hours_to_show = 120;
                refresh_interval = 0;
                min_y_axis = 180;
                max_y_axis = 215;
                entities = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                    name = "Weight";
                  }
                ];
              }
              {
                type = "custom:apexcharts-card";
                chart_type = "scatter";
                graph_span = "24h";
                span = {
                  start = "day";
                };
                header = {
                  show = true;
                  title = "Idris Weight (1 day)";
                  show_states = false;
                };
                yaxis = [
                  {
                    min = 180;
                    max = 215;
                    decimals = 1;
                  }
                ];
                apex_config = {
                  markers = {
                    size = 5;
                  };
                  stroke = {
                    width = 0;
                  };
                };
                series = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                    name = "Weight";
                    group_by = {
                      func = "raw";
                    };
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Weight vs 7-day average (30 days)";
                hours_to_show = 720;
                refresh_interval = 0;
                min_y_axis = 180;
                max_y_axis = 215;
                entities = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
                    name = "Weight";
                  }
                  {
                    entity = "sensor.idris_weight_7d_average";
                    name = "7d average";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Body composition (30 days)";
                hours_to_show = 720;
                refresh_interval = 0;
                entities = [
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_fat_percentage";
                    name = "Body fat %";
                  }
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_water_percentage";
                    name = "Body water %";
                  }
                  {
                    entity = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_skeletal_muscle_percentage";
                    name = "Skeletal muscle %";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Daily steps (30 days)";
                hours_to_show = 720;
                refresh_interval = 0;
                entities = [
                  {
                    entity = "sensor.idris_steps";
                    name = "Steps";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Idris Waist (30 days)";
                hours_to_show = 720;
                refresh_interval = 0;
                entities = [
                  {
                    entity = "input_number.idris_waist";
                    name = "Waist";
                  }
                ];
              }
              {
                type = "history-graph";
                title = "Idris Waist (5 days)";
                hours_to_show = 120;
                refresh_interval = 0;
                entities = [
                  {
                    entity = "input_number.idris_waist";
                    name = "Waist";
                  }
                ];
              }
            ];
          }
          {
            title = "Weather";
            path = "weather";
            icon = "mdi:home-thermometer-outline";
            panel = true;
            cards = [
              {
                type = "vertical-stack";
                cards = [
                  {
                    type = "thermostat";
                    entity = "climate.living_room_ac";
                    name = "Living Room AC";
                  }
                  {
                    type = "thermostat";
                    entity = "climate.bedroom_ac";
                    name = "Bedroom AC";
                  }
                  {
                    type = "entities";
                    title = "AC controls";
                    show_header_toggle = false;
                    entities = [
                      {
                        entity = "climate.living_room_ac";
                        name = "Living thermostat";
                      }
                      {
                        entity = "climate.bedroom_ac";
                        name = "Bedroom thermostat";
                      }
                      {
                        entity = "switch.third_reality_inc_3rsp02028bz";
                        name = "Living AC outlet";
                      }
                      {
                        entity = "switch.third_reality_inc_3rsp02028bz_2";
                        name = "Bedroom AC outlet";
                      }
                      {
                        entity = "fan.living_room_air_purifier";
                        name = "Living air purifier";
                      }
                      {
                        entity = "sensor.living_room_air_purifier_speed";
                        name = "Purifier speed";
                      }
                      {
                        entity = "sensor.3_power";
                        name = "Purifier power";
                      }
                      {
                        entity = "sensor.2_weather_temperature";
                        name = "Living temperature";
                      }
                      {
                        entity = "sensor.esp32_lan_node_dallas_temperature";
                        name = "Bedroom temperature";
                      }
                      {
                        entity = "sensor.2_weather_humidity";
                        name = "Living humidity";
                      }
                      {
                        entity = "sensor.lumi_lumi_weather_humidity";
                        name = "Bedroom humidity";
                      }
                    ];
                  }
                  {
                    type = "history-graph";
                    title = "AC Operation (24 hours)";
                    hours_to_show = 24;
                    refresh_interval = 0;
                    entities = [
                      {
                        entity = "climate.living_room_ac";
                        name = "Living thermostat";
                      }
                      {
                        entity = "climate.bedroom_ac";
                        name = "Bedroom thermostat";
                      }
                      {
                        entity = "switch.third_reality_inc_3rsp02028bz";
                        name = "Living AC outlet";
                      }
                      {
                        entity = "switch.third_reality_inc_3rsp02028bz_2";
                        name = "Bedroom AC outlet";
                      }
                      {
                        entity = "fan.living_room_air_purifier";
                        name = "Living air purifier";
                      }
                      {
                        entity = "sensor.living_room_air_purifier_speed";
                        name = "Purifier speed";
                      }
                      {
                        entity = "sensor.3_power";
                        name = "Purifier power";
                      }
                      {
                        entity = "sensor.2_weather_temperature";
                        name = "Living Temp";
                      }
                      {
                        entity = "sensor.esp32_lan_node_dallas_temperature";
                        name = "Bedroom Temp";
                      }
                    ];
                  }
                  {
                    type = "history-graph";
                    title = "Living Room vs Bedroom Temperature (24 hours)";
                    hours_to_show = 24;
                    refresh_interval = 0;
                    entities = [
                      {
                        entity = "sensor.2_weather_temperature";
                        name = "Living Room";
                      }
                      {
                        entity = "sensor.esp32_lan_node_dallas_temperature";
                        name = "Bedroom";
                      }
                    ];
                  }
                  {
                    type = "glance";
                    title = "Indoor climate now";
                    show_name = true;
                    show_icon = true;
                    show_state = true;
                    entities = [
                      {
                        entity = "sensor.2_weather_temperature";
                        name = "Living Temp";
                      }
                      {
                        entity = "sensor.esp32_lan_node_dallas_temperature";
                        name = "Bedroom Temp";
                      }
                      {
                        entity = "sensor.2_weather_humidity";
                        name = "Living Hum";
                      }
                      {
                        entity = "sensor.lumi_lumi_weather_humidity";
                        name = "Bedroom Hum";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };

        homeassistant = {
          customize = {
            "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight" = {
              friendly_name = "Idris Weight";
            };
            "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_fat_percentage" = {
              friendly_name = "Idris Body Fat %";
            };
            "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_body_mass_index" = {
              friendly_name = "Idris BMI";
            };
            "switch.third_reality_inc_3rsp02028bz" = {
              friendly_name = "Living Room AC Outlet";
              icon = "mdi:air-conditioner";
            };
            "switch.third_reality_inc_3rsp02028bz_2" = {
              friendly_name = "Bedroom AC Outlet";
              icon = "mdi:air-conditioner";
            };
            "switch.3" = {
              friendly_name = "Living Room Air Purifier Outlet";
              icon = "mdi:air-purifier";
            };
          };
        };

        input_number = {
          idris_waist = {
            name = "Idris Waist";
            icon = "mdi:tape-measure";
            min = 20;
            max = 60;
            step = 0.25;
            mode = "box";
            unit_of_measurement = "in";
          };
        };

        sensor = [
          {
            platform = "statistics";
            name = "Idris Weight 7d Average";
            unique_id = "idris_weight_7d_average";
            entity_id = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
            state_characteristic = "mean";
            max_age = {
              days = 7;
            };
            sampling_size = 200;
          }
          {
            platform = "statistics";
            name = "Idris Weight 7d Change";
            unique_id = "idris_weight_7d_change";
            entity_id = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
            state_characteristic = "change";
            max_age = {
              days = 7;
            };
            sampling_size = 200;
          }
        ];

        climate = [
          {
            platform = "generic_thermostat";
            name = "Living Room AC";
            unique_id = "living_room_ac";
            heater = "switch.third_reality_inc_3rsp02028bz";
            target_sensor = "sensor.2_weather_temperature";
            ac_mode = true;
            target_temp = 76.75;
            min_temp = 72;
            max_temp = 82;
            cold_tolerance = 1.25;
            hot_tolerance = 1.25;
            initial_hvac_mode = "cool";
            precision = 0.5;
            target_temp_step = 0.5;
          }
          {
            platform = "generic_thermostat";
            name = "Bedroom AC";
            unique_id = "bedroom_ac";
            heater = "switch.third_reality_inc_3rsp02028bz_2";
            target_sensor = "sensor.esp32_lan_node_dallas_temperature";
            ac_mode = true;
            target_temp = 76.75;
            min_temp = 72;
            max_temp = 82;
            cold_tolerance = 1.25;
            hot_tolerance = 1.25;
            initial_hvac_mode = "cool";
            precision = 0.5;
            target_temp_step = 0.5;
          }
        ];

        template = [
          {
            sensor = [
              {
                name = "Living Room Air Purifier Speed";
                unique_id = "living_room_air_purifier_speed";
                default_entity_id = "sensor.living_room_air_purifier_speed";
                icon = "mdi:fan-speed-2";
                availability = "{{ has_value('sensor.3_power') }}";
                state = ''
                  {% set watts = states('sensor.3_power') | float(0) %}
                  {% if is_state('switch.3', 'off') or watts < 5 %}
                    off
                  {% elif watts < 35 %}
                    low
                  {% elif watts < 60 %}
                    medium
                  {% else %}
                    high
                  {% endif %}
                '';
                attributes = {
                  watts = "{{ states('sensor.3_power') }}";
                  current = "{{ states('sensor.3_current') }}";
                };
              }
            ];
            fan = [
              {
                name = "Living Room Air Purifier";
                unique_id = "living_room_air_purifier";
                default_entity_id = "fan.living_room_air_purifier";
                state = "{{ states('switch.3') }}";
                icon = "mdi:air-purifier";
                turn_on = [
                  {
                    service = "switch.turn_on";
                    target = {
                      entity_id = "switch.3";
                    };
                  }
                ];
                turn_off = [
                  {
                    service = "switch.turn_off";
                    target = {
                      entity_id = "switch.3";
                    };
                  }
                ];
              }
            ];
          }
        ];

        automation = [
          {
            id = "idris_daily_weigh_in_reminder";
            alias = "Idris Daily Weigh-In Reminder";
            mode = "single";
            trigger = [
              {
                platform = "time";
                at = "08:30:00";
              }
            ];
            condition = [
              {
                condition = "template";
                value_template = ''
                  {% set weight = states.sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight %}
                  {{ weight is none
                     or weight.state in ['unknown', 'unavailable']
                     or as_timestamp(weight.last_updated, 0) < as_timestamp(today_at('00:00:00')) }}
                '';
              }
            ];
            action = [
              {
                service = "persistent_notification.create";
                data = {
                  title = "Daily weigh-in";
                  message = "Step on the Etekcity scale to log today's weight.";
                  notification_id = "daily_weigh_in_reminder";
                };
              }
            ];
          }
          {
            id = "idris_clear_weigh_in_reminder";
            alias = "Idris Clear Weigh-In Reminder";
            mode = "single";
            trigger = [
              {
                platform = "state";
                entity_id = "sensor.etekcity_smart_fitness_scale_d0_4d_00_4b_57_4a_idris_s_weight";
              }
            ];
            action = [
              {
                service = "persistent_notification.dismiss";
                data = {
                  notification_id = "daily_weigh_in_reminder";
                };
              }
            ];
          }
          {
            id = "idris_weekly_weight_trend";
            alias = "Idris Weekly Weight Trend";
            mode = "single";
            trigger = [
              {
                platform = "time";
                at = "09:00:00";
              }
            ];
            condition = [
              {
                condition = "time";
                weekday = [ "mon" ];
              }
              {
                condition = "template";
                value_template = ''
                  {{ states('sensor.idris_weight_7d_change') not in ['unknown', 'unavailable']
                     and states('sensor.idris_weight_7d_average') not in ['unknown', 'unavailable'] }}
                '';
              }
            ];
            action = [
              {
                service = "persistent_notification.create";
                data = {
                  title = "Weekly weight trend";
                  notification_id = "weekly_weight_trend";
                  message = ''
                    {% set change = states('sensor.idris_weight_7d_change') | float(0) %}
                    {% set average = states('sensor.idris_weight_7d_average') %}
                    {% if change <= -0.2 %}
                      Down {{ (change | abs) | round(2) }} kg over the last 7 days.
                    {% elif change >= 0.2 %}
                      Up {{ change | round(2) }} kg over the last 7 days.
                    {% else %}
                      Flat this week ({{ change | round(2) }} kg).
                    {% endif %}
                    7-day average: {{ average }} {{ state_attr('sensor.idris_weight_7d_average', 'unit_of_measurement') or 'kg' }}.
                  '';
                };
              }
            ];
          }
          {
            id = "living_room_air_purifier_ac_interlock";
            alias = "Living Room Air Purifier AC Interlock";
            mode = "single";
            trigger = [
              {
                platform = "homeassistant";
                event = "start";
              }
              {
                platform = "state";
                entity_id = "climate.living_room_ac";
              }
              {
                platform = "state";
                entity_id = "switch.3";
              }
            ];
            action = [
              {
                choose = [
                  {
                    conditions = [
                      {
                        condition = "template";
                        value_template = "{{ state_attr('climate.living_room_ac', 'hvac_action') == 'cooling' }}";
                      }
                    ];
                    sequence = [
                      {
                        condition = "state";
                        entity_id = "switch.3";
                        state = "on";
                      }
                      {
                        service = "switch.turn_off";
                        target = {
                          entity_id = "switch.3";
                        };
                      }
                    ];
                  }
                  {
                    conditions = [
                      {
                        condition = "template";
                        value_template = "{{ state_attr('climate.living_room_ac', 'hvac_action') != 'cooling' }}";
                      }
                    ];
                    sequence = [
                      {
                        condition = "state";
                        entity_id = "switch.3";
                        state = "off";
                      }
                      {
                        service = "switch.turn_on";
                        target = {
                          entity_id = "switch.3";
                        };
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
