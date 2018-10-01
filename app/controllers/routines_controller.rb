class RoutinesController < ApplicationController

    def index
        @week_hash = [{ "day" => "LUNES", "description" => "", "active" => "" }, { "day" => "MARTES", "description" => "", "active" => "" }, { "day" => "MIERCOLES", "description" => "", "active" => "" }, 
                    { "day" => "JUEVES", "description" => "", "active" => "" }, { "day" => "VIERNES", "description" => "", "active" => "" }]

        for date in Time.now.to_date.all_week do
            next if [0,6].include?(date.wday)
            @week_hash[date.wday - 1]["description"] = date_description(date)
        end
        if ![0,6].include?(Time.now.wday)
            @week_hash[Time.now.wday - 1]["active"] = 1 
        else
            @week_hash[4]["active"] = 1 
        end

    end

    def date_description(date)
        description = date.day.to_s + " DE " + month_description(date.month) + " " + date.year.to_s 
    end

    def month_description(month)
        case month
        when 1
            return "ENERO"
        when 2
            return "FEBRERO"
        when 3
            return "MARZO"
        when 4
            return "ABRIL"
        when 5
            return "MAYO"
        when 6
            return "JUNIO"
        when 7
            return "JULIO"
        when 8
            return "AGOSTO"
        when 9
            return "SEPTIEMBRE"
        when 10
            return "OCTUBRE"
        when 11
            return "NOVIEMBRE"
        when 12
            return "DICIEMBRE"
        end
    end
end
