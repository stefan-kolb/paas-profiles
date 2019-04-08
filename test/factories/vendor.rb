require_relative '../../app/models/vendor/vendor'

FactoryBot.define do
  factory :vendor, class: Profiles::Vendor do
    # mandatory properties
    name { 'unibapaas' }
    url { 'http://example.com' }
    revision { Date.today }
    status { 'production' }
    extensible { false }
    type { 'Generic' }

    hosting { FactoryBot.build(:hosting) }
    scaling { FactoryBot.build(:scaling) }
    pricings { [FactoryBot.build(:pricing)] }

    middlewares { [] }
    frameworks { [] }
    # service { [] }
    infrastructures { [FactoryBot.build(:infrastructure)] }
    # runtimes
    transient do
      language { 'ruby' }
    end

    after(:build) do |vendor, evaluator|
      vendor.runtimes = build_list(:runtime, 1, language: evaluator.language)
    end

    factory :vendor_with_distinct_runtimes do
      transient do
        runtime_count { 2 }
      end

      after(:build) do |vendor, evaluator|
        vendor.runtimes = build_list(:runtime, evaluator.runtime_count)
      end
    end

    factory :vendor_with_middleware do
      # middlewares
      transient do
        middleware_count { 5 }
      end

      after(:build) do |vendor, evaluator|
        vendor.middlewares = build_list(:middleware, evaluator.middleware_count)
      end
    end

    factory :vendor_with_frameworks do
      # frameworks
      transient do
        frameworks_count { 5 }
      end

      after(:build) do |vendor, evaluator|
        vendor.frameworks = build_list(:framework, evaluator.frameworks_count)
      end
    end

    # FIXME: does not create infrastructure
    factory :vendor_with_infrastructures do
      # infrastructures
      transient do
        infrastructures_count { 5 }
      end

      after(:build) do |vendor, evaluator|
        vendor.infrastructures = build_list(:infrastructure, evaluator.infrastructures_count)
      end
    end
  end
end
