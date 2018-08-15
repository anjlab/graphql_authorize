# frozen_string_literal: true

module GraphqlAuthorize
  module AuthAdapters
    class Pundit < Base
      def authorize
        if policy&.respond_to?(pundit_action)
          policy.send(pundit_action)
        else
          false
        end
      end

      private

      def policy
        @policy ||= ::Pundit.policy(context[:current_user], subject)
      end

      def pundit_action
        "#{action}?"
      end

      def action
        field_definition.authorize.first
      end

      def subject
        field_definition.authorize.last
      end
    end
  end
end
