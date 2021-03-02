--パイル・アームド・ドラゴン
--
--Script by REIKAI
function c100277002.initial_effect(c)
	--special summon (self)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100277002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100277002)
	e1:SetCost(c100277002.cost)
	e1:SetTarget(c100277002.sptg)
	e1:SetOperation(c100277002.spop)
	c:RegisterEffect(e1) 
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100277002,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100277022)
	e2:SetCondition(c100277002.condition)
	e2:SetCost(c100277002.cost)
	e2:SetTarget(c100277002.target)
	e2:SetOperation(c100277002.operation)
	c:RegisterEffect(e2)
end
function c100277002.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsRace(RACE_DRAGON) and (c:IsAttribute(ATTRIBUTE_WIND) or c:IsLevelAbove(7))
end
function c100277002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100277002.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c100277002.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c100277002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100277002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100277002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c100277002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100277002.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c100277002.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(tg,REASON_COST)
	e:SetLabelObject(tg:GetFirst())
end
function c100277002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g:GetFirst(),1,0,0)
end
function c100277002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tgc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(tgc:GetLevel()*300)
		tc:RegisterEffect(e0)
		--check
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c100277002.checkop)
		Duel.RegisterEffect(e1,tp)
		--cannot announce
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(c100277002.atkcon)
		e2:SetTarget(c100277002.atktg)
		e1:SetLabelObject(e2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100277002.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,100277002)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,100277002,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c100277002.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),100277002)>0
end
function c100277002.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
