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
	return g:GetClassCount(Card.GetLinkAttribute)==1 or g:GetClassCount(Card.GetLinkRace)==1
end
function c100257011.lmlimit(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end
function c100257011.cfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c100257011.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalAttribute(),c:GetOriginalRace(),tp)
end
function c100257011.eqfilter(c,att,race,tp)
	return (c:GetOriginalAttribute()==att or c:GetOriginalRace()==race) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
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
		local flag=0
		local att=tc:GetOriginalAttribute()
		local race=tc:GetOriginalRace()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c100257011.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,att,race,tp)
		local gc=g:GetFirst()
		if gc:IsLocation(LOCATION_DECK) then
			flag=1
		end
		if not Duel.Equip(tp,gc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c100257011.eqlimit)
		gc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e2)
		if flag==1 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetLabel(gc:GetCode())
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
