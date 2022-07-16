--同契魔術
--Script by 奥克斯
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	local sumtype=bit.band(c:GetType(),TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
	return c:IsFaceup() and c:GetType()&sumtype>0 
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do 
			local p1ayer=tc:GetControler()
			local rtype=tc:GetType()&(TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0) 
			e1:SetLabel(rtype)
			e1:SetTarget(s.sumlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p1ayer)
			tc=g:GetNext()
		end
		local rt=g:Filter(s.rtfilter,nil,tp)
		local fs=g:Filter(s.fsfilter,nil,tp)
		local sy=g:Filter(s.syfilter,nil,tp)
		local xyz=g:Filter(s.xyzfilter,nil,tp)
		local lk=g:Filter(s.lkfilter,nil,tp)
		local g1=g:Filter(Card.IsControler,nil,tp)
		if #rt<2 and #fs<2 and #sy<2 and #xyz<2 and #lk<2 and #g1>0 then
			local tc1=g1:GetFirst()
			while tc1 do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				tc1=g1:GetNext()
			end  
		end
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(e:GetLabel())
end
function s.rtfilter(c,tp)
	return c:GetType()&TYPE_RITUAL~=0 and c:IsControler(tp)
end
function s.fsfilter(c,tp)
	return c:GetType()&TYPE_FUSION~=0 and c:IsControler(tp)
end
function s.syfilter(c,tp)
	return c:GetType()&TYPE_SYNCHRO~=0 and c:IsControler(tp)
end
function s.xyzfilter(c,tp)
	return c:GetType()&TYPE_XYZ~=0 and c:IsControler(tp)
end
function s.lkfilter(c,tp)
	return c:GetType()&TYPE_LINK~=0 and c:IsControler(tp)
end
