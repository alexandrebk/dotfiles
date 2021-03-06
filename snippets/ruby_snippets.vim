Snippet route         <{verb}> <{name}>, to: '<{controller}>#<{action}>', as: '<{action}>', on: :member, on: :collection
Snippet namespace     namespace :<{}> do<CR>end
Snippet res           resources :<{}>, only: [:<{}>]
Snippet ress          resources :<{}>, only: [:<{}>]


Snippet controller    class <{}>sController < <{}>ApplicationController<CR>end
Snippet module        module <{name}><CR>end
Snippet defparams     def <{var}>_params<CR>params.require(:<{var}>).permit(:<{}>)<CR>end
Snippet defnew        def new<CR>@<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.new<CR>end
Snippet defcreate     def create<CR>@<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.new(<{var}>_params)<{}><CR>end
Snippet defupdate     def update<CR>@<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.find(params[:id])<CR>@<{var}>.update(<{var}>_params)<CR>end
Snippet permit        params.require(:<{var}>).permit(:<{}>)
Snippet params        params[:<{id}>]
Snippet ba            before_action :<{}>
Snippet only          only: [:<{}>]
Snippet rt            redirect_to <{}>_path
Snippet find          @<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.find(params[:id])<{}>
Snippet all           @<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.all<{}>
Snippet new           @<{var}> = <{var:substitute(@z,'.*','\u&','g')}>.new<{}>
Snippet update        @<{var}>.update(<{var}>_params)<{}>


Snippet model         class <{name}> < ApplicationRecord<CR><{}>end


Snippet migration     class <{}> < ActiveRecord::Migration[5.1]<{}><CR>end
Snippet addcol        add_column :<{table}>, :<{var}>, :<{type}>
Snippet addref        add_reference :<{table}>, :<{var}>, foreign_key: true
Snippet removecol     remove_column :<{table}>, :<{var}>
Snippet renamecol     rename_column :<{table}>, :<{old_column}>, :<{new_column}>


Snippet rspec         require 'rails_helper'<CR><CR>RSpec.describe "<{}>" do<CR>end
Snippet describe      describe "<{}>" do<CR>end
Snippet context       context "<{}>" do<CR>end
Snippet before        before { <{}> }
Snippet it            it "<{}>" do<CR>end
Snippet fillin        fill_in "<{field}>", with: "<{text}>"
Snippet fill          fill_in "<{field}>", with: "<{text}>"
Snippet expect        expect(<{}>).to <{}>
Snippet timecop       Timecop.freeze(DateTime.new(2020,1,1)) do<CR><{}><CR>end
Snippet testexple     visit root_path<CR>click_on "text"<CR>fill_in "id" with: "text"<CR>select "test", from:<CR>click_on "text"<CR>expect().to eq


Snippet def           def <{}><CR>end
Snippet ternary       <{}> ? <{}> : <{}>
Snippet each          each do |<{}>|
Snippet map           map do |<{}>|
Snippet do            do<{}><CR>end
Snippet if            if <{}><CR>end
Snippet ife           if <{}><CR>else<CR>end
Snippet class         class <{}><CR><{}><CR>end


Snippet stringfortime strftime("%d/%m/%Y<{}> - %Hh%M}>")
Snippet env           ENV["<{}>"]<{}>
