module Postmark
  module SpamCheck
    class Report
      attr_reader :email, :score, :details
      attr_accessor :error

      def initialize(email)
        @email = email
        @score = nil
        @error = nil
        @details = []
      end

      def load_results(results)
        # Truthy success means the report was generated successfully.
        if results['success']
          results_for_success(results)
        else
          results_for_failure(results)
        end

        self
      end

    private
      def results_for_success(results)
        @score = results['score']
        parse_spamassassin_report(results['report'])
      end

      def results_for_failure(results)
        @error = results['message']
      end

      def parse_spamassassin_report(report_text = nil)
        return [] unless report_text

        # NOTE: Possible multi-line description. Example:

        #  pts rule name               description
        # ---- ---------------------- --------------------------------------------------
        #  0.0 FREEMAIL_FROM          Sender email is commonly abused enduser mail provider
        #                             (hello[at]example.com)
        last_rule = nil

        # Ignore the first two lines.
        report_text.split(/\n/)[2..-1].each do |line|
          rule, description = line[5..-1].strip.split(/\s{2,}/, 2).map(&:strip)

          if description
            points = line[0..3].strip.to_f
            last_rule = { points: points, rule: rule, description: description }
            @details << last_rule

          # Nil description means second line of description is in "rule".
          # Tack it on to the description of the last one.
          elsif last_rule
            last_rule[:description] << " #{rule}"
          end
        end
      rescue StandardError => error
        @error = error.message
      end
    end
  end
end
