module Aqi
  BREAKPOINTS = {
    good: {
      aqi_low: 0.0,
      aqi_high: 50.0,
      breakpoint_low: 0.0,
      breakpoint_high: 12.0
    },
    moderate: {
      aqi_low: 51.0,
      aqi_high: 100.0,
      breakpoint_low: 12.1,
      breakpoint_high: 35.4
    },
    unhealthy_sensitive: {
      aqi_low: 101.0,
      aqi_high: 150.0,
      breakpoint_low: 35.5,
      breakpoint_high: 55.4
    },
    unhealthy: {
      aqi_low: 151.0,
      aqi_high: 200.0,
      breakpoint_low: 55.5,
      breakpoint_high: 150.4
    },
    very_unhealthy: {
      aqi_low: 201.0,
      aqi_high: 300.0,
      breakpoint_low: 150.5,
      breakpoint_high: 250.4
    },
    hazardous_1: {
      aqi_low: 301.0,
      aqi_high: 400.0,
      breakpoint_low: 250.5,
      breakpoint_high: 350.4
    },
    hazardous_2: {
      aqi_low: 401.0,
      aqi_high: 500.0,
      breakpoint_low: 350.5,
      breakpoint_high: 500.4
    },
    hazardous_3: {
      aqi_low: 501.0,
      aqi_high: 999.0,
      breakpoint_low: 500.5,
      breakpoint_high: 99999.9
    }
  }.freeze

  def self.aqi_from_pm25(pm25)
    raise 'Invalid pm2.5 value' unless pm25 && pm25 >= 0
    params = { raw_pm25: pm25 }

    category =
      case pm25
      when (BREAKPOINTS[:hazardous_3][:breakpoint_low]..) then 'hazardous_3'
      when (BREAKPOINTS[:hazardous_2][:breakpoint_low]..) then 'hazardous_2'
      when (BREAKPOINTS[:hazardous_1][:breakpoint_low]..) then 'hazardous_1'
      when (BREAKPOINTS[:very_unhealthy][:breakpoint_low]..) then 'very_unhealthy'
      when (BREAKPOINTS[:unhealthy][:breakpoint_low]..) then 'unhealthy'
      when (BREAKPOINTS[:unhealthy_sensitive][:breakpoint_low]..) then 'unhealthy_sensitive'
      when (BREAKPOINTS[:moderate][:breakpoint_low]..) then 'moderate'
      when (BREAKPOINTS[:good][:breakpoint_low]..) then 'good'
      end

    params = params.merge(BREAKPOINTS[category.to_sym])
    calculate_aqi(params)
  end

  def self.calculate_aqi(params)
    a = params[:aqi_high] - params[:aqi_low]
    b = params[:breakpoint_high] - params[:breakpoint_low]
    c = params[:raw_pm25] - params[:breakpoint_low]

    ((a / b) * c + params[:aqi_low]).round
  end

  private_class_method :calculate_aqi
end