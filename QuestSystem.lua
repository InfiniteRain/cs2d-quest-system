--[[

Info:
To add quest go to quests.lua

--]]

function initArray(m)
	local array = {}
	for i = 1, m do
		array[i] = 0
	end
	eturn array
end

kills=initArray(32)
qc=initArray(32)

addhook("kill","addscore")
function addscore(killer)
	kills[killer]=kills[killer]+1
end

dofile("sys/lua/quests.lua")
for i=1,#quests do
	quests[i].var=initArray(32)
end

addhook("say","getquest")
function getquest(id,text)
	for i=1,#quests do
		if text==quests[i].text then
			if qc[id]==1 then
				msg2(id,"�255000000You already take a quest!@C")
			end
			if qc[id]==0 then
				if quests[i].var[id]==1 then
					msg2(id,"�255000000You already take that quest!@C")
				elseif quests[i].var[id]==2 then
					msg2(id,"�255000000You already complete this quest!@C")
				end
				if quests[i].var[id]==0 then
					msg2(id,"�000255000You take a quest!@C")
					qc[id]=1
					kills[id]=0
					quests[i].var[id]=1
				end
			end
		end
	end
end

addhook("ms100","completecheck")
function completecheck()
	for i=1,#quests do
		for id=1,32 do
			if quests[i].var[id]==1 then
				if kills[id]==quests[i].kills then
					msg2(id,"You complete the quest! Reward: "..quests[i].itemidrewardname.."@C")
					quests[i].var[id]=2
					parse("equip "..id.." "..quests[i].itemidreward)
					qc[id]=0
				end
			end
		end
	end
end

addhook("say","infocheck")
function infocheck(id,text)
	for i=1,#quests do
		if text=="!info" then
			if qc[id]==0 then
				msg2(id,"�255000000You dont start any quests!@C")
			end
			if quests[i].var[id]==1 then
				if qc[id]==1 then
					msg2(id,"Kills: "..kills[id]..", to complete quest: "..quests[i].kills)
				end
			end
		end
	end
end