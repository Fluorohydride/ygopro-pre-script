--圣骑士与圣剑之王国 卡美洛
function c100209281.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100209281.desreptg)
	e1:SetValue(c100209281.desrepval)
	e1:SetOperation(c100209281.desrepop)
	c:RegisterEffect(e1)
	--banish & set field & search|spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100209281,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,100209281)
	e2:SetTarget(c100209281.settg)
	e2:SetOperation(c100209281.setop)
	c:RegisterEffect(e2)
end
function c100209281.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsSetCard(0x107a)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100209281.desfilter(c,e)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100209281.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100209281.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c100209281.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c100209281.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c100209281.desrepval(e,c)
	return c100209281.repfilter(c,e:GetHandlerPlayer())
end
function c100209281.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100209281)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c100209281.selfilter(c,e,tp)
	if c:IsSetCard(0xa7) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	else
		return c:IsSetCard(0x207a) and c:IsAbleToHand()
	end
end
function c100209281.setfilter(c)
	return c:IsCode(55742055) and not c:IsForbidden() and c:IsType(TYPE_FIELD) and c:CheckUniqueOnField(tp)
end
function c100209281.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100209281.setfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100209281.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0
		and c:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100209281,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(c100209281.retcon)
		e1:SetOperation(c100209281.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetValue(0)
		c:RegisterFlagEffect(100209281,RESET_PHASE+PHASE_STANDBY,0,2)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c100209281.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
					and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100209281.selfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) 
					and Duel.SelectYesNo(tp,aux.Stringid(100209281,0)) 
			then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100209281.selfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
				local sc=sg:GetFirst()
				if sc:IsSetCard(0xa7) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
				else 
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				end
			end
		end
	end
end
function c100209281.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(100209281)~=0
end
function c100209281.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	e:Reset()
end
