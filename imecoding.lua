-- This is a Lua script for accelerating coding, implementing in google ime.
-- INSTALL(Windows):
-- 1)Download and install the google ime :http://www.google.cn/intl/zh-CN/ime/pinyin/
-- 2)Download this file and right click, chosing the item like "install to the google ime..."
-- OK, that is all! Don not be surprise it is so easy!
-- Now open a text editor and active the google ime in chinese input mode(I know you may need not to input chinese),
-- And then, type "iiih" following a Enter, now it is working for you!
-- Welcome to imecoding world!
----------------------------------------------------------------------
----------------------------------------------------------------------

--Setting rule: key = 'string you want to code'
IMGCODING_COMMAND_SETTING_T = {
	h = '<!DOCTYPE HTML>'..'\n'..
		 '<html lang="en">'..'\n'..
		 '    <head>'..'\n'..
		 '        <meta charset="UTF-8">'..'\n'..
		 '        <title></title>'..'\n'..
		 '    </head>'..'\n'..
		 '    <body>'..'\n'..
		 '    </body>'..'\n'..
		 '</html>'..'\n',
	ht = '<!DOCTYPE HTML>'..'\n'..
			'<html lang="en">'..'\n'..
			'	<head>'..'\n'..
			'		<meta charset="UTF-8"/>'..'\n'..
			'		<meta name="viewport" content="width=device-width; initial-scale=1.0; maximun-scale=1.0; user-scalable=0;"/>'..'\n'..
			'		<meta name="description" content=""/>'..'\n'..
			'		<meta name="keywords" content=""/>'..'\n'..

			'		<title></title>'..'\n'..
			'		<link href="" rel="stylesheet" type="text/css" charset="utf-8"/>'..'\n'..
			'		<script src="" type="text/javascript" charset="utf-8"></script>'..'\n'..
			'	</head>'..'\n'..
			'	<body>'..'\n'..
			'		<header>'..'\n'..
			'			<nav class="site-nav"></nav>'..'\n'..
			'		</header>'..'\n'..
			'		<div class="main">'..'\n'..
			'			<section id="primary"></section>'..'\n'..
			'			<aside id="secondary"></aside>'..'\n'..
			'		</div>'..'\n'..
			'		<footer></footer>'..'\n'..

			'		<script src="" type="text/javascript" charset="utf-8"></script>'..'\n'..
			'	</body>'..'\n'..
			'</html>'..'\n', 
	s = '<script src="" type="text/javascript" charset="utf-8"></script>'..'\n',
	l = '<link href="" rel="stylesheet" type="text/css" charset="utf-8"/>'..'\n',
	
	f = 'function(){}'..'\n'
}

function getTagAttrs(arg)
	local ATTR_VALUE_EXP_T = {
			 tagName = '%a+',
			 tagNum = '%*%d*',
			 tagId = '%#%w*',
			 tagClassName = '%$%w*',
			 tagCusAttr = '%[.*%]',
			 tagContent = '%@%w*',
			 subTag = '%>.*'
		  }
	local tagAttrsT = {}
	local charStart = 0
	local charEnd = 0
    local attrValue = ''	
	
	for k,v in pairs(ATTR_VALUE_EXP_T) do 	
		charStart, charEnd = string.find(arg,v)
		if charStart and charEnd then
			attrValue = string.sub(arg, charStart, charEnd)			
		end
		if k == 'tagName' then
			tagAttrsT['tagName'] = attrValue
		elseif k == 'tagNum' then
			if attrValue ~= '' then
				tagAttrsT['tagNum'] = string.sub(attrValue, 2)	
			else
				tagAttrsT['tagNum'] = 1	
			end
		elseif k == 'tagId' then
			tagAttrsT['tagId'] = string.sub(attrValue, 2) 		
		elseif k == 'tagClassName' then
			tagAttrsT['tagClassName'] = string.sub(attrValue, 2)	
		elseif k == 'tagCusAttr' then
			tagAttrsT['tagCusAttr'] = string.sub(attrValue, 2, -2)	
		elseif k == 'tagContent' then
			tagAttrsT['tagContent'] = string.sub(attrValue, 2)	
		elseif k == 'subTag' then
			tagAttrsT['subTag'] = string.sub(attrValue, 2)			
		end	
		attrValue = ''
	end
	
	return tagAttrsT	
end
function createHtml(T)
	local html = ''
	local bool = (T.tagName ~= '')
	if bool then
		for i = 1, T.tagNum, 1 do
			html = html .. '<'..T.tagName
			if T.tagId ~= '' then
				html = html ..' id="'..T.tagId .. i..'"'
			end
			if T.tagClassName ~= '' then
				html = html ..' class="'..T.tagClassName..'"'
			end
			if T.tagCusAttr ~= '' then
				local p = string.find(T.tagCusAttr,':')
				local attr = string.sub(T.tagCusAttr,1,p-1)
				local attrVal = string.sub(T.tagCusAttr,p+1)
				html = html ..' '.. attr ..'="'.. attrVal ..'"'
			end			
			if T.tagContent ~= '' then
				html = html ..'>'..T.tagContent
			else
				html = html ..'>'
			end			
			if T.subTag ~= '' then			
				html = html .. '\n'.. createTag(T.subTag)
			end			
			html = html ..'</'..T.tagName..'>\n'			
		end
	end
	return html
end
function createTag(arg)	
	local html = ''
	local tagAttrs = {}	
	tagAttrs = getTagAttrs(arg)	
	html = createHtml(tagAttrs)	
	return html	
end
function customCmd(cmd)	
	local result = ''
	for k,v in pairs(IMGCODING_COMMAND_SETTING_T) do 
		if k == cmd then
			result = v
			break
		end
	end	
	if result == '' then
		result = createTag(cmd)
	end	
	return result
end

ime.register_command("ii", "customCmd", "Ime Coding Template", "none", "enjoy conding :)")