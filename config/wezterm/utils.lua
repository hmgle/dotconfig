local M = {}

function M.merge_tables(t1, t2)
	for k, v in pairs(t2) do
		-- 深合并仅当两侧都是哈希表；数组（keys/mouse_bindings/ssh_domains 等）整体替换，
		-- 否则 local.lua 覆盖时会按下标互相污染。空表按新值处理，可整体清空数组字段。
		if (type(v) == "table") and (type(t1[k] or false) == "table")
			and (t1[k][1] == nil) and (v[1] == nil) then
			M.merge_tables(t1[k], v)
		else
			t1[k] = v
		end
	end
	return t1
end

function M.merge_lists(t1, t2)
	local result = {}
	for _, v in ipairs(t1) do
		table.insert(result, v)
	end
	for _, v in ipairs(t2) do
		table.insert(result, v)
	end
	return result
end

return M
