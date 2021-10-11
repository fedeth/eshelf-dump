module SystemUtils

	LOCKS_DIR_PATH = "#{Rails.root}/tmp/locks"
	LOG_PATH = "#{Rails.root}/log"

	def execute_exclusively_with_logs(label, &block)
		Dir.mkdir(LOCKS_DIR_PATH) unless File.exists?(LOCKS_DIR_PATH)
		logger = Logger.new("#{LOG_PATH}/#{label}.log")
		begin
			file_path = "#{LOCKS_DIR_PATH}/#{label}"
			File.open(file_path, File::CREAT|File::EXCL)
			logger.info("TASK STARTED")
			block.call(logger)
			logger.info("TASK ENDED")
			File.delete(file_path)
		rescue Errno::EEXIST => _
			logger.error("CONCURRENT EXECUTIONS ATTEMPT: task not executed")
			exit 1
		end
	end

end