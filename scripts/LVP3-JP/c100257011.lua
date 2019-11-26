--ユニオン・キャリアー

--Scripted by mallu11
function c100257011.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c100257011.lcheck)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c100257011.lmlimit)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100257011,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100257011)
	e2:SetTarget(c100257011.eqtg)
	e2:SetOperation(c100257011.eqop)
	c:RegisterEffect(e2)
end
function c100257011.lcheck(g,lc)
	if #g<2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return c1:GetLinkAttribute()&c2:GetLinkAttribute()>0 or c1:GetLinkRace()&c2:GetLinkRace()>0
end
function c100257011.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c100257011.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c100257011.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalAttribute(),c:GetOriginalRace(),tp)
end
function c100257011.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==att or c:GetOriginalRace()==race)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c100257011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100257011.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100257011.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100257011.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100257011.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c100257011.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetOriginalAttribute(),tc:GetOriginalRace(),tp)
		local sc=g:GetFirst()
		local res=sc:IsLocation(LOCATION_DECK) and true or false
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c100257011.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		if res then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetLabel(sc:GetCode())
			e3:SetTarget(c100257011.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c100257011.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100257011.splimit(e,c)
	return c:IsCode(e:GetLabel())
end
