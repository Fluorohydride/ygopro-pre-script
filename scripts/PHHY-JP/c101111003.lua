--ギャラクリボー
--
--Script by Trishula9
function c101111003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101111003.spcon)
	e1:SetCost(c101111003.spcost)
	e1:SetTarget(c101111003.sptg)
	e1:SetOperation(c101111003.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c101111003.reptg)
	e3:SetValue(c101111003.repval)
	e3:SetOperation(c101111003.repop)
	c:RegisterEffect(e3)
end
function c101111003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c101111003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101111003.spfilter(c,e,tp)
	return c:IsCode(93717133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101111003.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c101111003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101111003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsLocation(LOCATION_MZONE) then
		local a=Duel.GetAttacker()
		if a:IsAttackable() and a:IsRelateToEffect(e) and not a:IsImmuneToEffect(e) then
			Duel.BreakEffect()
			local mg=Duel.GetMatchingGroup(c101111003.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if Duel.ChangeAttackTarget(tc) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101111003,2))
				and c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and c:IsCanOverlay() and aux.NecroValleyFilter()(c) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local sc=g:Select(tp,1,1,nil):GetFirst()
				if not sc:IsImmuneToEffect(e) then
					Duel.Overlay(sc,Group.FromCards(c))
				end
			end
		end
	end
end
function c101111003.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x55,0x7b)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c101111003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101111003.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101111003.repval(e,c)
	return c101111003.repfilter(c,e:GetHandlerPlayer())
end
function c101111003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end