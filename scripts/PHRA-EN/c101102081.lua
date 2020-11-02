--Mahaama the Fairy Dragon
function c101102081.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102081,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c101102081.sumcon)
	e1:SetTarget(c101102081.sumtg)
	e1:SetOperation(c101102081.sumop)
	c:RegisterEffect(e1)
end
function c101102081.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)>0 and ep==tp
end
function c101102081.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101102081.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_EFFECT)
		local opt=Duel.SelectOption(tp,aux.Stringid(101102081,0),aux.Stringid(101102081,1))
		if opt==0 then
			Duel.Recover(tp,ev,REASON_EFFECT)
		else
			Duel.Damage(1-tp,ev,REASON_EFFECT)
		end
	end
end