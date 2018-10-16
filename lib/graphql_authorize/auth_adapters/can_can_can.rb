# frozen_string_literal: true

module GraphqlAuthorize
  module AuthAdapters
    class CanCanCan < Base
      def authorize
        unless field_definition.authorize.is_a?(Array)
          raise ArgumentError, I18n.t("graphql_authorize.auth.arrayargs")
        end

        unless source.respond_to?(:can?)
          raise ArgumentError, I18n.t("graphql_authorize.auth.canrespond")
        end

        source.can?(*field_definition.authorize)
      end

      private

      def auth_adapter_source
        GraphqlAuthorize.config.auth_adapter_source
      end

      def source
        @source ||=
          if auth_adapter_source
            auth_adapter_source.call(context)
          else
            Ability.new(context[:current_user])
          end
      end
    end
  end
end
