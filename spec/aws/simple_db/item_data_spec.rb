# Copyright 2011 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

module AWS
  class SimpleDB

    describe ItemData do

      context '#initialize' do

        it 'requires no constructor arguments' do
          lambda { ItemData.new }.should_not raise_error
        end

        it 'should store the name' do
          ItemData.new(:name => 'foo').name.should == "foo"
        end

        it 'should store the attributes' do
          ItemData.new(:attributes => { 'foo' => %w(1 2) }).attributes["foo"].
            should == %w(1 2)
        end

        it 'should store the domain' do
          domain = Domain.new("foo")
          ItemData.new(:domain => domain).domain.should be(domain)
        end

        it 'should be able to get the item from the domain' do
          domain = double("domain")
          item = double("item")
          domain.should_receive(:[]).with("foo").and_return(item)
          ItemData.new(:name => "foo",
                       :domain => domain).item.should be(item)
        end

        it 'should extract the name from an object' do
          obj = double("obj",
                       :name => "foo")
          ItemData.new(:response_object => obj).name.should == "foo"
        end

        it 'should prefer the :name option to the name from a response object' do
          obj = double("obj",
                       :name => "foo")
          ItemData.new(:response_object => obj,
                       :name => "bar").name.should == "bar"
        end

        let(:response_with_attributes) do
          double("obj",
                 :attributes =>
                 [double("att1",
                         :name => "foo",
                         :value => "1"),
                  double("att2",
                         :name => "foo",
                         :value => "2"),
                  double("att3",
                         :name => "bar",
                         :value => "baz")])
        end

        it 'should extract the attributes from an object' do
          ItemData.new(:response_object => response_with_attributes).
            attributes.should == { "foo" => %w(1 2), "bar" => ["baz"] }
        end

        it 'should prefer the :attributes option to attributes from an object' do
          ItemData.new(:response_object => response_with_attributes,
                       :attributes => {}).attributes.should == {}
        end

      end

    end

  end
end
