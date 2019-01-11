--落消しのパズロミノ
--
--Script by mercury233
function c101008049.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c101008049.mfilter,2,2,c101008049.lcheck)
	c:EnableReviveLimit()
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101008049,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101008049)
	e1:SetCondition(c101008049.lvcon)
	e1:SetTarget(c101008049.lvtg)
	e1:SetOperation(c101008049.lvop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008049,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101008049+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101008049.destg)
	e2:SetOperation(c101008049.desop)
	c:RegisterEffect(e2)
end
function c101008049.mfilter(c)
	return c:IsLevelAbove(0)
end
function c101008049.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function c101008049.cfilter(c,lg)
	return c:IsFaceup() and c:IsLevelAbove(0) and lg:IsContains(c)
end
function c101008049.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c) and eg:IsExists(c101008049.cfilter,1,nil,c:GetLinkedGroup())
end
function c101008049.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=eg:Filter(c101008049.cfilter,nil,c:GetLinkedGroup())
	g:KeepAlive()
	local ct={}
	for i=1,8 do
		if not g:IsExists(Card.IsLevel,1,nil,i) then table.insert(ct,i) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceNumber(tp,table.unpack(ct))
	e:SetLabel(lv)
	e:SetLabelObject(g)
end
function c101008049.efilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(0) and not c:IsLevel(lv)
end
function c101008049.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	local g=e:GetLabelObject()
	local tg=g:Filter(c101008049.efilter,nil,lv)
	g:DeleteGroup()
	local tc=tg:GetFirst()
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=tg:Select(tp,1,1,nil):GetFirst()
	end
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101008049.tgfilter1(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c101008049.tgfilter2,tp,0,LOCATION_MZONE,1,nil,e,c:GetLevel())
end
function c101008049.tgfilter2(c,e,lv)
	return c:IsFaceup() and c:IsLevelAbove(0) and c:IsLevel(lv) and c:IsCanBeEffectTarget(e)
end
function c101008049.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101008049.tgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c101008049.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c101008049.tgfilter2,tp,0,LOCATION_MZONE,1,1,nil,e,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c101008049.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
