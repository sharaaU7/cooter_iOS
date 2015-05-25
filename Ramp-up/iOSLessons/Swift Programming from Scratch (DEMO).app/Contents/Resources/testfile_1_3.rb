has_no_output

values_for :width, [640, 720, 1280, 1920, 7680]
values_for :height, [480, 576, 720, 1080, 4320]

expects_value :numberOfPixels do |width, height|
	width * height
end
