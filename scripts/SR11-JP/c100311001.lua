--ドラグニティアームズ－グラム
--Dragunity Arma Gram
--Script by JoyJ
function c100311001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100311001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,100311001)
	e1:SetCost(c100311001.spcost)
	e1:SetTarget(c100311001.sptg)
	e1:SetOperation(c100311001.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100311001,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100311001+100)
	e2:SetTarget(c100311001.distg)
	e2:SetOperation(c100311001.disop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,100311001+200)
	e3:SetCondition(c100311001.eqcon)
	e3:SetTarget(c100311001.eqtg)
	e3:SetOperation(c100311001.eqop)
	c:RegisterEffect(e3)
end

function c100311001.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_DRAGON+RACE_WINDBEAST)
end
function c100311001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100311001.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsRace,RACE_DRAGON,RACE_WINDBEAST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsRace,RACE_DRAGON,RACE_WINDBEAST)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c100311001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100311001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100311001.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_MONSTER) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c100311001.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c100311001.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		local ct=Duel.GetMatchingGroupCount(c100311001.eqfilter,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 and tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-ct*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c100311001.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()~=tp
end
function c100311001.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100311001.cfilter,1,nil,tp)
end
function c100311001.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and not c:IsForbidden()
end
function c100311001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ct>0
		and eg:IsExists(c100311001.filter,1,nil,e,tp) end
	local g=eg:Filter(c100311001.filter,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,ct,nil)
	else
		tc=g
	end
	e:SetLabelObject(tc)
	tc:ForEach(Card.CreateEffectRelation,e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,#tc,0,0)
end
function c100311001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if c:IsFaceup() then
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c,true,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c100311001.eqlimit)
				tc:RegisterEffect(e1)
			end
			Duel.EquipComplete()
		end
	end
end
function c100311001.eqlimit(e,c)
	return e:GetOwner()==c
end
